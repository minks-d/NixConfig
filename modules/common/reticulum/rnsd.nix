{
  pkgs,
  lib,
  config,
  ...
}:
let
  interfaceType = with lib.types; (submodule {
    options = {
      enabled = lib.mkOption {
        type = bool;
        default = false;
        description = "Whether or not to enable the given interface";
        example = true;
      };
      name = lib.mkOption {
        type = str;
        default = "Interface";
        example = "My Interface";
      };
      type = lib.mkOption {
        type = enum [
          "AutoInterface"
          "BackboneInterface"
          "TCPServerInterface"
          "TCPClientInterface"
          "UDPInterface"
          "I2PInterface"
          "RNodeInterface"
          "RNodeMultiInterface"
          "SerialInterface"
          "PipeInterface"
          "KISSInterface"
          "AX25KISSInterface"
          "CustomInterface"
        ];
      };
      additionalSettings = lib.mkOption {
        type = attrsOf (oneOf [
          str
          bool
          (listOf str)
        ]);
        default = {};
        example = {
          group_id = "reticulum";
          multicast_address_type = "permanent";
          devices = ["wlan0" "eth1"];
          ignored_devices = ["tun0" "eth0"];
        };
      };
    };
  });
  
  interfacesType = (lib.types.listOf interfaceType);
in {
  options = {
    services.rnsd = {
      enable = lib.mkEnableOption "rnsd";
      configDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/rnsd";
        example = "$HOME/.rnsd/";
      };
      configFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = /path/to/reticulum/config;
      };
      settings = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        reticulum = lib.mkOption {
          type = lib.types.attrsOf (lib.types.oneOf [
            lib.types.str
            lib.types.number
            lib.types.bool
            lib.types.path
          ]);
          default = {
          };
          example = {
            enable_transport = false;
            share_instance = true;
            instance_name = "default";
          };
        };
        logging = {
          loglevel = lib.mkOption {
            type = lib.types.numbers.between 0 7;
            default = 4;
            example = 0;
          };
        };
        interfaces = lib.mkOption {
          type = interfacesType;
          default = [
            {
              name = "DefaultInterface";
              type = "AutoInterface";
              enabled = true;
            }
          ];
        };
      };
    };
  };

  config = let
    utils = import ./utils.nix lib;
    cfg = config.services.rnsd;
    configFile = let
      reticulumList = (lib.attrsToList cfg.settings.reticulum);
      loggingList = (lib.attrsToList cfg.settings.logging);
      interfacesList = cfg.settings.interfaces;
    in with utils;
      builtins.toFile
        "config"
        (if (cfg.configFile == null)
         then
           lib.concatStringsSep "\n" [
             (lib.foldl retFold "[reticulum]" reticulumList)
             (lib.foldl loggingFold "[logging]" loggingList)
             (lib.foldl interfacesFold "[interfaces]" interfacesList)
           ]
         else
           (builtins.readFile cfg.configFile));
  in
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = ((cfg.settings.enable && cfg.configFile == null) || (!cfg.settings.enable && cfg.configFile != null));
          message = ''
                  services.rnsd: One of either (settings.enable == true) OR (configFile != null) must be true.
                    '';
        }
      ];
      environment.systemPackages = [
        (pkgs.symlinkJoin {
          name = "reticulum-wrapped";
          paths = [ pkgs.rns ];
          buildInputs = [ pkgs.makeBinaryWrapper ];

          #Tell all bundled utilities where the config directory is
          postBuild = let
            #Programs that accept --config for reticulum config location
            configPrograms = [
              "rnstatus"
              "rncp"
              "rnid"
              "rnpkg"
              "rnsd"
              "rnir"
              "rnpath"
              "rnprobe"
              "rnsh"
              "rnx"
            ];
            #Programs that accept --rnsconfig for reticulum config location
            rnsConfigPrograms = [
              "git-remote-rns"
              "rngit"
            ];
            #Programs that do not accept a reticulum config location
            _otherPrograms = [
              "rnodeconfig"
              "rngcs"
            ];
            configFunc = next: acc: (lib.concatStringsSep "\n" [acc ''wrapProgram "$out/bin/${next}" --add-flags "--config ${cfg.configDir}"'']);
            rnsConfigFunc = next: acc: (lib.concatStringsSep "\n" [acc ''wrapProgram "$out/bin/${next}" --add-flags "--rnsconfig ${cfg.configDir}"'']);
          in lib.concatStringsSep "\n" [
            (lib.foldr configFunc "" configPrograms)
            (lib.foldr rnsConfigFunc "" rnsConfigPrograms)
          ];
        })
      ];
      systemd.services.rnsd = {
        enable = true;
        description = "Reticulum Network Stack Daemon";
        restartIfChanged = true;
        restartTriggers = [
          configFile
        ];
        serviceConfig = {
          Type="simple";
          Restart="always";
          RestartSec=3;
          StateDirectory = "rnsd";
          ExecStart="${pkgs.rns}/bin/rnsd --service --config ${cfg.configDir}";
        };
        preStart = ''
      mkdir -p ${cfg.configDir};
      cp ${configFile} ${cfg.configDir}/config
                   '';
        after = ["multi-user.target"];
        wantedBy = ["multi-user.target"];
      };
    };
}

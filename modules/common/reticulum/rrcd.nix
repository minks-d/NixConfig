{
  config,
  lib,
  inputs,
  pkgs,
  system,
  ...
}:
{
  options.minksd.rrcd = {
    enable = lib.mkEnableOption "rrcd";
    package = lib.mkOption {
      type = lib.types.package;
      default = inputs.local-packages.packages.${system}.rrcd;
    };
    configDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/rrcd/";
    };
    rrcd = {
      hub = {
        configdir = lib.mkOption {
          type = lib.types.path;
          default = config.minksd.rnsd.configDir;
        };
        identity_path = lib.mkOption {
          default = "${config.minksd.rrcd.configDir}/hub_identity";
        };
        room_registry_path = lib.mkOption {
          default = "${config.minksd.rrcd.configDir}/rooms.toml";
        };
        announce_on_start = lib.mkOption {
          default = true;
        };
        announce_period_s = lib.mkOption {
          default = 900;
        };
        hub_name = lib.mkOption {
          default = "RRC Hub";
        };
        greeting = lib.mkOption {
          default = "Welcome!";
        };
        trusted_identities = lib.mkOption {
          default = [];
        };
        banned_identities = lib.mkOption {
          default = [];
        };
        room_registry_prune_after_s = lib.mkOption {
          default = 2592000;
        };
        room_registry_prune_interval_s =lib.mkOption {
          default = 3600.0;
        };
        room_invite_timeout_s = lib.mkOption {
          default = 900.0;
        };
        include_joined_member_list = lib.mkOption {
          default = true;
        };
        max_nick_bytes = lib.mkOption {
          default = 32;
        };
        max_room_name_bytes = lib.mkOption {
          default = 64;
        };
        max_msg_body_bytes = lib.mkOption {
          default = 350;
        };
        max_rooms_per_session = lib.mkOption {
          default = 32;
        };
        rate_limit_msgs_per_minute = lib.mkOption {
          default = 240;
        };
        ping_interval_s = lib.mkOption {
          default = 0.0;
        };
        ping_timeout_s = lib.mkOption {
          default = 0.0;
        };
        enable_resource_transfer = lib.mkOption {
          default = true;
        };
        max_resource_bytes = lib.mkOption {
          default = 262144;
        };
        max_pending_resource_expectations = lib.mkOption {
          default = 8;
        };
        resource_expectation_ttl_s = lib.mkOption {
          default = 30.0;
        };
      };
      logging = {
        level = lib.mkOption {
          default = "INFO";
        };
        rns_level = lib.mkOption {
          default = "WARNING";
        };
        console = lib.mkOption {
          default = true;
        };
        file = lib.mkOption {
          default = "";
        };
        format = lib.mkOption {
          default = "%(asctime)s %(levelname)s %(name)s[%(threadName)s]: %(message)s";
        };
        datefmt = lib.mkOption {
          default = "";
        };
      };
    };
    rooms = lib.mkOption {
      default = {
        rooms.general = {};
      };
    };
  };


  config =
    let
      cfg = config.minksd.rrcd;
      stateDir = "/var/lib/rrcd/";
      configFile = pkgs.writers.writeTOML "rrcd.toml" cfg.rrcd;
      roomsFile = pkgs.writers.writeTOML "rooms.toml" cfg.rooms;
    in lib.mkIf (cfg.enable) {
      nixpkgs.config.allowUnfreePredicate = (_: true);
      minksd.rnsd.enable = true;
      systemd.services.rrcd = {
        enable = true;
        description = "Reticulum Relay Chat Daemon";
        restartIfChanged = true;
        restartTriggers = [
          configFile
          roomsFile
          cfg.configDir
        ];
        serviceConfig = {
          Type="simple";
          Restart="always";
          RestartSec=3;
          StateDirectory = "rrcd";
          ExecStart="${cfg.package}/bin/rrcd --config ${stateDir}/rrcd.toml --configdir ${config.minksd.rnsd.configDir}";
        };
        preStart = ''
                 mkdir -p ${stateDir}
                 cp ${configFile} ${stateDir}/rrcd.toml
                 cp ${roomsFile} ${stateDir}/rooms.toml
                 ${if !(builtins.pathExists cfg.rrcd.hub.identity_path) then "${pkgs.rns}/bin/rnid -g ${cfg.rrcd.hub.identity_path}" else ""}
                   '';
        after = ["multi-user.target"];
        wantedBy = ["multi-user.target"];
      };
    };
}

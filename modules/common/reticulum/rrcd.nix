{
  config,
  pkgs,
  lib,
  local-packages,
  ...
}:
{
  options.services.rrcd = {
    enable = lib.mkEnableOption "rrcd";
    settings = {};
      
  };


  config =
    let
      cfg = config.services.rrcd;
      stateDir = "/var/lib/rrcd/";
    in lib.mkIf (cfg.enable) {
      systemd.services.rrcd = {
        enable = true;
        description = "Reticulum Relay Chat Daemon";
        restartIfChanged = true;
        serviceConfig = {
          Type="simple";
          Restart="always";
          RestartSec=3;
          StateDirectory = "rrcd";
          ExecStart="${local-packages.rns}/bin/rrcd --config ${stateDir} --configdir ${config.services.rns.configdir}";
        };
        after = ["multi-user.target"];
        wantedBy = ["multi-user.target"];
      };
    };
}

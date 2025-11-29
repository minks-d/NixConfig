{
  config,
  upkgs,
  pkgs,
  lib,
  ...
}: {
  options = {
    tuned = {
      enable = lib.mkEnableOption "Power and Performance daemon.";
      profile = lib.mkOption {
        default = ''balanced'';
      };
    };
    services.tuned.activeProfile = lib.mkOption {
      default = config.tuned.profile;
    };
  };
  
  config =
    let
      tuned-pkg = pkgs.tuned;
      tuned-profile = config.services.tuned.activeProfile;
    in
    lib.mkIf (config.tuned.enable) {
      environment.etc."tuned/active_profile".text = "${tuned-profile}\n";
      systemd.services.tuned = {
        unitConfig = {
          StartLimitBurst = 3;
          StartLimitInvervalSec = 15;
        };
        serviceConfig = {
         # ExecStartPost = ''${pkgs.dbus}/bin/dbus-send --system --dest=com.redhat.tuned --type=method_call --print-reply "/Tuned" com.redhat.tuned.control.switch_profile string:"${config.services.tuned.activeProfile}"'';
        };
      };
      services.tuned = {
        enable = true;
        package = tuned-pkg;
        settings = {
          dynamic_tuning = true;
        };
      };
    };
}
  

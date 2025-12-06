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
    };
    services.tuned.profile = lib.mkOption {
      default = "balanced";
    };
  };
  
  config =
    let
      tuned-pkg = pkgs.tuned;
      tuned-profile = config.services.tuned.activeProfile;
    in
      lib.mkIf (config.tuned.enable) {
        environment.sessionVariables = {
          NIXOS_TUNED_PROFILE = "test";
        };
        systemd.services.tuned-change-profile = {
          enable = true;
          requires = ["tuned.service" "dbus.service"];
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${pkgs.bash}/bin/bash -c  ${./try-till-complete.bash}";
          };
        };
        services.tuned = {
          enable = true;
          package = tuned-pkg;
          settings = {
            dynamic_tuning = true;
          };
          profile = "desktop";
        };
      };
}
  

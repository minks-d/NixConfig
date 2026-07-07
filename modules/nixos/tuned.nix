{
  config,
  pkgs,
  lib,
  ...
}:
{
  options = {
    tuned = {
      enable = lib.mkEnableOption "Power and Performance daemon.";
    };
  };

  config = lib.mkIf (config.tuned.enable) {
    services.tuned = {
      enable = true;
      settings = {
        dynamic_tuning = true;
      };
      package = pkgs.tuned;
    };
  };
}

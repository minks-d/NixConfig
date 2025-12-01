{
  options,
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    nh = {
      enable = lib.mkEnableOption {
        description = "Enable nh.";
        default = false;
      };
    };
  };

  config = lib.mkIf config.nh.enable {
    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 30d";
      };
    };
  };
}

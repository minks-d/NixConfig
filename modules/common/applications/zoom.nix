{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    zoom = {
      enable = lib.mkEnableOption {
        description = "Enable zoom.";
        default = false;
      };
    };
  };

  config = lib.mkIf (config.gui.enable && config.zoom.enable) {
    unfreePackages = ["zoom"];
    environment.systemPackages = [pkgs.zoom-us];
  };
}

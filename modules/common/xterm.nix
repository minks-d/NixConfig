{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    xterm = {
      enable = lib.mkEnableOption {
        description = "Enable xterm";
        default = true;
      };
    };
  };

  config = lib.mkIf (config.gui.enable && config.xterm.enable) {
    home-manager.users.${config.user} = {
      xresources.properties = {
        "xterm*Foreground" = "Gainsboro";
        "xterm*background" = "rgb:1/2/23";
        "xterm*faceName" = "Cascadia Code";
        "xterm*faceSize" = 11;
      };
    };
    environment.systemPackages = [
      pkgs.xterm
    ];
  };

}

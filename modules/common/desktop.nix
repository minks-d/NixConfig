{ pkgs, ... }:
{
  environment.pathsToLink = [ "/libexec" ];
  services.displayManager.defaultSession = "none+i3";
  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        i3status # gives you the default i3 status bar
        i3lock # default i3 screen locker
        rofi
      ];
    };
  };
}

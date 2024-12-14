{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    desktop = {
      hyprland = {
        enable = lib.mkEnableOption {
          description = "Enable hyprland WM.";
          default = false;
        };
      };
    };
  };

  config = lib.mkIf (config.gui.enable && config.desktop.hyprland.enable) {
    programs.hyprland.enable = true;
    environment.systemPackages = with pkgs; [
      wofi
      pavucontrol
      hyprland
      bibata-cursors
    ];
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    programs.hyprland.withUWSM = true;
    programs.hyprland.xwayland.enable = true;
    programs.waybar.enable = true;

    services.dbus.enable = true;
    services.xserver.enable = true;
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
    xdg.portal.wlr.enable = true;

    home-manager.users.${config.user} = {config, ...}: {
      #Set link to hyprland config file
      home.file.".config/hypr/hyprland.conf".source = config.lib.file.mkOutOfStoreSymlink ./hyprland.conf;

      #Set link to hyprland uwsm files
      home.file.".config/uwsm/env-hyprland".source = config.lib.file.mkOutOfStoreSymlink ./env-hyprland;
      home.file.".config/uwsm/env".source = config.lib.file.mkOutOfStoreSymlink ./env;

      #Set link cursors into the correct home directory
      home.file.".local/share/icons/".source = "${pkgs.bibata-cursors}/share/icons/";
      home.file.".local/share/icons/".recursive = true;
    };
  };
}

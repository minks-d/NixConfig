{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  options = {
    desktop = {
      cosmic = {
        enable = lib.mkEnableOption {
          description = "Enable Cosmic DE.";
          default = false;
        };
      };
    };
  };
  config = lib.mkIf (config.gui.enable && config.desktop.cosmic.enable) {
    environment.systemPackages = with pkgs; [
      bibata-cursors
      xwayland-satellite
      grim
      slurp
      wl-clipboard
    ];
    
    # Enable the COSMIC login manager
    services.displayManager.cosmic-greeter.enable = true;

    # Enable the COSMIC desktop environment
    services.desktopManager.cosmic.enable = true;
    
    environment.variables.NIXOS_OZONE_WL = "1";
    environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;

    home-manager.users.${config.user} = {config, ...}: {
        };
  };
}

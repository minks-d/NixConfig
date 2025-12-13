{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.waybar.enable = lib.mkEnableOption "waybar";

  config = lib.mkIf config.waybar.enable {
    environment.systemPackages = with pkgs; [
    ];
    home-manager.users.${config.user} =
      { config, ... }:
      {
        programs.waybar = {
          enable = true;
          systemd.enable = true;
        };
        xdg.configFile.waybar = {
          enable = true;
          source = ./waybar.json;
        };
      };
  };
}

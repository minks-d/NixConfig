{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.hyprlock.enable = lib.mkEnableOption {
    default = false;
  };

  config = lib.mkIf (config.hyprlock.enable == true) {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs)
        hyprlock
        ;
    };

    home-manager.users."${config.user}" = {
      home.file.".config/hypr/hyprlock.conf".source = ./hyprlock.conf;
    };
  };

}

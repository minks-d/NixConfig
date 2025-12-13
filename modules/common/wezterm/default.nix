{
  lib,
  config,
  pkgs,
  ...
}:
{

  options.wezterm.enable = lib.mkEnableOption { default = true; };

  config = lib.mkIf (config.wezterm.enable) {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs)
        wezterm
        ;
    };

    home-manager.users.${config.user} = {
      home.file.".wezterm.lua".source = ./.wezterm.lua;
    };

  };

}

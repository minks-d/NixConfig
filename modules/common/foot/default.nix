{
  options,
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    foot = {
      enable = lib.mkEnableOption {
        description = "Enable foot, a wayland terminal.";
        default = false;
      };
    };
  };

  config = lib.mkIf config.foot.enable {
    programs.foot.enable = true;
    programs.foot.enableZshIntegration = false;
    programs.zsh.interactiveShellInit = ". ${./.zshrc}";

    home-manager.users.${config.user} = {
      home.file.".config/foot/foot.ini".text = builtins.readFile ./foot.ini;
    };
  };
}

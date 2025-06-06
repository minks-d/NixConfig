{
  lib,
  options,
  config,
  pkgs,
  ...
}: {
  options = {
    zsh = {
      enable = lib.mkEnableOption {
        description = "Enable zsh";
        default = false;
      };
    };
  };

  config = lib.mkIf config.zsh.enable {
    programs.zsh.enable = true;
    home-manager.users.${config.user} = {
      programs = {
        zsh.enable = true;
        zsh.oh-my-zsh.enable = true;
        zsh.oh-my-zsh.custom = "/home/${config.user}/.zshrc";
        zsh.oh-my-zsh.extraConfig = ''
                 export ZSH="${pkgs.oh-my-zsh}/share/oh-my-zsh"

          #For flatpak
          export XDG_DATA_DIRS=$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share
                 source $ZSH/oh-my-zsh.sh

                 alias pushconfig="cd /etc/nixos; sudo git commit -a -m \"$(date -Iminutes -u)\"; sudo git push; cd -"
                 alias config="sudo nvim /etc/nixos/"
                 alias rebuild="sudo nixos-rebuild --flake /etc/nixos/ switch;"
                 alias upgrade="cd /etc/nixos; sudo nix flake update; cd -; rebuild;"
                 alias update="cd /etc/nixos; sudo nix flake update; cd -"
                 alias logout="i3-msg exit"


                 ZSH_THEME="amuse"
        '';
      };
    };
    users.defaultUserShell = pkgs.zsh;
  };
}

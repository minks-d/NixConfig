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
        fzf = {
          enable = true;
          enableZshIntegration = true;
        };
        zsh = {
          enable = true;
          oh-my-zsh.enable = true;
          oh-my-zsh.custom = "/home/${config.user}/.zshrc";
          oh-my-zsh.extraConfig = ''

                 export ZSH="${pkgs.oh-my-zsh}/share/oh-my-zsh"

                 #For flatpak
                 export XDG_DATA_DIRS=$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share

                 source $ZSH/oh-my-zsh.sh

                 alias config-edit="emacs /home/minksd/nixos/"
                 alias config-test="sudo nixos-rebuild --flake /home/minksd/nixos test"
                 alias config-rebuild="sudo nixos-rebuild --flake /home/minksd/nixos/ boot"
                 alias config-update="cd /home/minksd/nixos; sudo nix flake update; cd -"
                 alias emacs="emacsclient"

                 alias sudo="run0" #Sudo is disabled on this system, use run0 instead

                 ZSH_THEME="amuse"
        '';
        };
      };
    };
    users.defaultUserShell = pkgs.zsh;
  };
}

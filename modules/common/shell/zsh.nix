{lib, config, pkgs, ...}:

{
  	home-manager.users.${config.user} = {
	  programs = {
	  zsh.enable = true;
	  zsh.oh-my-zsh.enable = true;
	  zsh.oh-my-zsh.custom = "/home/${config.user}/.zshrc";
	  zsh.oh-my-zsh.extraConfig = ''
	  
export ZSH="$HOME/.oh-my-zsh"
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
	}

	  
	

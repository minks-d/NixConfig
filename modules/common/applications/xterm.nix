{lib, config, pkgs, ... }:
{
  options = {
  	xterm = {
	  enable = lib.mkEnableOption {
	    description = "Enable xterm";
	    default = true;
	    };
	    };
	    };

  config = lib.mkIf (config.gui.enable && config.xterm.enable){
  	environment.systemPackages = [
		pkgs.xterm
		];
	home-manager.users.${config.user}.xresources.properties = {
	  "XTerm*foreground" = "rgb:211/211/211";
	  "XTerm*background" = "rgb:1/12/19";
	  "XTerm*faceName" = "Cascadia Code"; 
	  };
	};

}

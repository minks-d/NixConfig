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
		};
	

}

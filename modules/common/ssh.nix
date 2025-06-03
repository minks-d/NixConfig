{lib, config, pkgs, ...}:
{

options = {
    	ssh = {
	  server = {
	    enable = lib.mkEnableOption {
	      description = "Enable the openssh sshd server";
	      default = false;
	      };
	      };
  };
  };


	config = lib.mkIf (config.ssh.server.enable) {
  	services.openssh = {
	  enable = true;
	  settings.PermitRootLogin = "no";
	};


  };
  



}

{lib, config, pkgs,...}:

{
	config = {
	home-manager.users.${config.user} = {
	  home.packages = with pkgs; [
	  xclip
	  ];
	};
	};
}

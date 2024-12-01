{
	config,
		pkgs,
		lib,
		...
}:
{

	options = {
		teams = {
			enable = lib.mkEnableOption {
				description = "Enable Teams.";
				default = false;
			};
		};
	};

	config = lib.mkIf (config.gui.enable && config.teams.enable) {

    environment.systemPackages = [ pkgs.teams-for-linux ];
	}
}
 

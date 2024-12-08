{pkgs, lib, config, ...}:{

	options = {
		desktop = {
			sway = {
				enable = lib.mkEnableOption {
					description = "Enable sway WM.";
					default = false;
				};
			};
		};
	};

	config = lib.mkIf (config.gui.enable && config.desktop.sway.enable) {
		programs.sway.enable = true;
		environment.systemPackages = [
			pkgs.sway
			pkgs.kitty
		];
		services.greetd = {
			enable = true;
			settings = rec {
				initial_session = {
					command = "${pkgs.sway}/bin/sway";
					user = "minksd";
				};
				default_session = initial_session;
			};
	};

		xdg.portal.wlr.enable = true;
	};

	}

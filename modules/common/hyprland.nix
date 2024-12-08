{pkgs, lib, config, ...}:{

	options = {
		desktop = {
			hyprland = {
				enable = lib.mkEnableOption {
					description = "Enable hyprland WM.";
					default = false;
				};
			};
		};
	};

	config = lib.mkIf (config.gui.enable && config.desktop.hyprland.enable) {
		programs.hyprland.enable = true;
		environment.systemPackages = [
			pkgs.kitty
			pkgs.hyprland
			pkgs.wofi
		];
		environment.sessionVariables.NIXOS_OZONE_WL = "1";
		programs.hyprland.withUWSM = true;
		programs.hyprland.xwayland.enable = true;
		programs.waybar.enable = true;
		services.dbus.enable = true;
		services.greetd = {
			enable = true;
			settings = rec {
				initial_session = {
					command = "Hyprland";
					user = "minksd";
				};
				default_session = initial_session;
			};
	};
		xdg.portal.wlr.enable = true;
	};

	}

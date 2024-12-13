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
			pkgs.wofi
			pkgs.pavucontrol
		];
		environment.sessionVariables.NIXOS_OZONE_WL = "1";

		programs.hyprland.withUWSM = true;
		programs.hyprland.xwayland.enable = true;
		programs.waybar.enable = true;

		programs.foot.enable = true;


		services.dbus.enable = true;
		services.xserver.enable = true;
		services.displayManager.sddm.enable = true;
		services.displayManager.sddm.wayland.enable = true;
		xdg.portal.wlr.enable = true;
	};

	}

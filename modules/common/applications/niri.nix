{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  options = {
    desktop = {
      niri = {
        enable = lib.mkEnableOption {
          description = "Enable niri WM.";
          default = false;
        };
      };
    };
  };
  config = lib.mkIf (config.gui.enable && config.desktop.niri.enable) {
    environment.systemPackages = with pkgs; [
      bibata-cursors
      fuzzel
      xwayland-satellite
      swaylock
    ];
    programs.niri.enable = true;
    programs.niri.package = pkgs.niri-unstable;

    services.displayManager.enable = true;
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
    environment.variables.NIXOS_OZONE_WL = "1";

    home-manager.users.${config.user} = {config, ...}: {
      nixpkgs.overlays = [inputs.niri.overlays.niri];

      programs.niri.settings = {
        binds = {
          "Mod+Q".action.spawn = "foot";
          "Mod+R".action.spawn = "fuzzel";
          "Mod+Shift+L".action.spawn = "swaylock";
          "Mod+P".action = config.lib.niri.actions.quit;
          "Mod+F".action = config.lib.niri.actions.fullscreen-window;
          "Mod+C".action = config.lib.niri.actions.close-window;
          "Mod+H".action = config.lib.niri.actions.focus-column-left;
          "Mod+L".action = config.lib.niri.actions.focus-column-right;
          "Ctrl+Shift+P".action = config.lib.niri.actions.screenshot;
        };
        spawn-at-startup = [
          {
            command = [
              "xwayland-satellite"
            ];
          }
        ];
        environment = {
          DISPLAY = ":0";
        };

        outputs = {
          "DP-2" = {
            mode = {
              width = 1920;
              height = 1080;
              refresh = 75.001;
            };
            position = {
              x = 1600;
              y = 0;
            };
          };
          "HDMI-A-4" = {
            mode = {
              width = 1600;
              height = 900;
              refresh = 74.889;
            };
            position = {
              x = 0;
              y = 0;
            };
          };
        };
        cursor.size = 22;
        cursor.theme = "Bibata-Modern-Classic";
        layout.border.active = 0;
        layout.border.inactive = 2;
        layout.center-focused-column = "never";
        layout.default-column-width.proportion = 0.75;
        input.focus-follows-mouse.enable = true;
      };
    };
  };
}

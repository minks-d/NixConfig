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
    ];
    programs.niri.enable = true;
    programs.niri.package = pkgs.niri-unstable;
    services.displayManager.enable = true;
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;

    home-manager.users.${config.user} = {config, ...}: {
      nixpkgs.overlays = [inputs.niri.overlays.niri];

      programs.niri.settings = {
        binds = {
          "Mod+Q".action.spawn = "foot";
          "Mod+R".action.spawn = "fuzzel";
          "Mod+C".action = config.lib.niri.actions.close-window;
          "Mod+F".action = config.lib.niri.actions.fullscreen-window;
          "Ctrl+Shift+P".action = config.lib.niri.actions.screenshot;
        };
        outputs = {
          "DP-2" = {
            mode = {
              width = 1920;
              height = 1080;
              refresh = 75.0;
            };
          };
          "HDMI-A-4" = {
            mode = {
              width = 1600;
              height = 900;
              refresh = 75.0;
            };
            position = {
              x = -1920;
              y = 0;
            };
          };
        };
        cursor.size = 22;
        cursor.theme = "Bibata-Modern-Classic";
        layout.center-focused-column = "never";
        layout.default-column-width.proportion = 0.45;
        input.focus-follows-mouse.enable = true;
      };
    };
  };
}

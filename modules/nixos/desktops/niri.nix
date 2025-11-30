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
      grim
      slurp
      wl-clipboard
    ];
    programs.niri.enable = true;
    programs.niri.package = pkgs.niri-unstable;

    services.displayManager.enable = true;
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
    environment.variables.NIXOS_OZONE_WL = "1";

    home-manager.users.${config.user} = {config, ...}: {
      nixpkgs.overlays = [inputs.niri.overlays.niri];

      programs.niri.settings = with config.lib.niri.actions; let
        zsh = spawn "zsh" "-c";
      in {
        binds = {
          "Mod+Q".action.spawn = "wezterm";
          "Mod+R".action.spawn = "fuzzel";
          "Mod+P".action = quit;
          "Mod+F".action = fullscreen-window;
          "Mod+C".action = close-window;
          "Mod+H".action = focus-column-left;
          "Mod+L".action = focus-column-right;
          "Mod+S".action = zsh ''grim -g "$(slurp)" - | wl-copy'';

#          "Ctrl+Shift+P".action = screenshot;
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
        window-rules = [
          {
            geometry-corner-radius =
              let
                r = 8.0;
              in
                {
                  top-left = r;
                  top-right = r;
                  bottom-left = r;
                  bottom-right = r;
                };
          }
        ];
        debug = {
          honor-xdg-activation-with-invalid-serial = [];
        };
        cursor.size = 22;
        cursor.theme = "Bibata-Modern-Classic";
        layout.border.active = 0;
        layout.border.inactive = 2;
        layout.gaps = 8;
        layout.struts = {
          top = 8;
          bottom = 8;
          left = 2;
          right = 2;
        };
        layout.center-focused-column = "never";
        layout.default-column-width.proportion = 0.75;
        input.focus-follows-mouse.enable = true;
      };
    };
  };
}

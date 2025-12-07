{pkgs, lib, config, inputs, ...}:{

  options.noctalia.enable = lib.mkEnableOption { default = false;};
  
  config = lib.mkIf (config.noctalia.enable){
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs)
        pavucontrol;
    };
    
    home-manager.users.${config.user} = {config, ...}: {
      imports = [
        inputs.noctalia.homeModules.default
      ];
      programs.noctalia-shell.systemd.enable = true;
      programs.noctalia-shell.enable = true;
      programs.noctalia-shell.settings = {
        ui.fontDefault = "M+1Code Nerd Font Propo";
        location.weatherEnabled = false;

        colorSchemes = {
          predefinedScheme = "Kanagawa";
        };

        wallPaper = {
          overviewEnabled = true;
          randomEnabled = true;
          randomIntervalSec = 120;
          transitionDuration = 1500;
        };

        bar = {
          widgets = {
            right = [
              {
                id = "ScreenRecorder";
              }
              {
                id = "Tray";
              }
              {
                id = "NotificationHistory";
              }
              {
                id = "Volume";
              }
              {
                id = "Clock";
              }
            ];
          };
        };
        controlCenter.shortcuts = {
          left = [
            {
              id = "ScreenRecorder";
            }
            {
              id = "WallpaperSelector";
            }
          ];
          right = [
            {
              id = "Notifications";
            }
            {
              id = "PowerProfile";
            }
            {
              id = "KeepAwake";
            }
            {
              id = "NightLight";
            }
          ];
        };

        audio = {
          visualizerQuality = "low";
          preferredPlayer = "spotify";
        };
        network = {
          wifiEnabled = false;
        };
      };
    };
  };
}

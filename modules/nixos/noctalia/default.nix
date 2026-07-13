{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{

  options.noctalia.enable = lib.mkEnableOption { default = false; };

  config = lib.mkIf (config.noctalia.enable) {
    services.upower.enable = true;
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs)
        pavucontrol
        ;
    };

    home-manager.users.${config.user} =
      let
        statTypes = ["cpu_usage" "cpu_temp" "ram_pct" "swap_pct"];
        sysmonFromType = type: {name = type; value = {
          type = "sysmon";
          stat = type;
        };};
        all-stats = lib.listToAttrs (lib.forEach statTypes sysmonFromType);
      in
        {
          imports = [
            inputs.noctalia.homeModules.default
          ];
          programs.noctalia.systemd.enable = true;
          programs.noctalia.enable = true;
          programs.noctalia.settings = {
            shell = {
              font_family = "M+1Code Nerd Font Propo";
              polkit_agent = true;
              show_location = false;
            };

            widget =  {
            } // all-stats;
            
            bar = {
              order = [ "main" ];
              main = {
                radius = 0;
                margin_ends = 0;
                margin_edge = 0;
                capsule = true;
                start = ["active_window" ] ++ statTypes;
                center = ["workspaces"];
                end = lib.mkBefore [ "screenrecorder" "tray" "notifications" "volume" "network" "clock"];
              };
            };
            theme = {
              builtin = "Kanagawa";
            };

            wallpaper = {
              directory = "${inputs.wallpapers}/8k Japan/";
              automation = {
                enabled = true;
                interval_seconds = 60;
                order = "random";
              };
              transition_duration = 1500;
            };
          };
        };
  };
}

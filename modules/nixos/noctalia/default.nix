{pkgs, lib, config, inputs, system, ...}:{

  options = {
    noctalia = lib.mkEnableOption {
      default = false;
    };
  };

  config = lib.mkIf (config.noctalia.enable){
    
    environment.systemPackages = [
      inputs.noctalia.packages.${system}.default
    ];

    home-manager.users.${config.user} = {config, ...}: {
      imports = [
        inputs.noctalia.homeModules.default
      ];
      programs.noctalia-shell.systemd.enable = true;

      programs.noctalia-shell.settings = {
        ui.fontDefault = "M+1Code Nerd Font Propo";
        };
      };
  };
}

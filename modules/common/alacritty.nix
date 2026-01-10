{lib, config, ...}:

{
  options.alacritty.enable = lib.mkEnableOption {
    default = false;
    description = "Alacritty is a modern terminal emulator that comes with sensible defaults, but allows for extensive configuration.";
  };
  config = let
    cfg = config.alacritty;
  in
    lib.mkIf (cfg.enable == true) {
      home-manager.users.${config.user} = {
        programs.alacritty = {
          enable = true;
          settings = {
            font.normal = {
              family = "Cascadia Code NF";
              style = "Regular";
            };
            font.size = 10;
          };
        };
      };
    };
}

{
  options,
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    direnv = {
      enable = lib.mkEnableOption {
        description = "Enable direnv.";
        default = false;
      };
    };
  };

  config = lib.mkIf config.direnv.enable {
    programs.direnv.enable = true;
  };
}

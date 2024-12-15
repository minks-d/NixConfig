{
  config,
  upkgs,
  pkgs,
  lib,
  ...
}: {
  options.gaming.lutris.enable = lib.mkEnableOption "Lutris game launcher.";

  config = lib.mkIf (config.gaming.lutris.enable && pkgs.stdenv.isLinux) {
    environment.systemPackages = [
      upkgs.lutris
    ];
  };
}

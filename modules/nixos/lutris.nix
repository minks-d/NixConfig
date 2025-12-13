{
  config,
  upkgs,
  pkgs,
  lib,
  ...
}:
{
  options.lutris.enable = lib.mkEnableOption "Lutris game launcher.";

  config = lib.mkIf (config.lutris.enable && pkgs.stdenv.isLinux) {
    environment.systemPackages = with upkgs; [
      lutris
      wineWowPackages.waylandFull
      protobuf
    ];
  };
}

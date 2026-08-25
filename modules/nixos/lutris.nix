{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.lutris.enable = lib.mkEnableOption "Lutris game launcher.";

  config = lib.mkIf (config.lutris.enable && pkgs.stdenv.hostPlatform.isLinux) {
    environment.systemPackages = with pkgs; [
      lutris
      wineWow64Packages.waylandFull
      protobuf
    ];
  };
}

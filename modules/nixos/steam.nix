{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.steam.enable = lib.mkEnableOption "Steam game launcher.";

  config = lib.mkIf (config.steam.enable && pkgs.stdenv.isLinux) {
    hardware.steam-hardware.enable = true;
    unfreePackages = [
      "steam"
    ];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
      gamescopeSession.enable = true;
    };
    programs.gamescope.capSysNice = true;

  };
}

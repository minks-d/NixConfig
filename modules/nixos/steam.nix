{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.steam.enable = lib.mkEnableOption "Steam game launcher.";

  config = lib.mkIf (config.steam.enable && pkgs.stdenv.hostPlatform.isLinux) {
    environment.systemPackages = [ pkgs.mangohud ];
    hardware.steam-hardware.enable = true;
    unfreePackages = [
      "steam"
    ];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      gamescopeSession.enable = true;
    };
    programs.gamescope.capSysNice = false;
    programs.gamemode.enable = true;

  };
}

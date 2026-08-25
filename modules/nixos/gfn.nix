{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.gfn.enable = lib.mkEnableOption "Geforce now.";

  config = lib.mkIf (config.gfn.enable && pkgs.stdenv.hostPlatform.isLinux) {
    environment.systemPackages = with pkgs; [
      gfn-electron
    ];
  };
}

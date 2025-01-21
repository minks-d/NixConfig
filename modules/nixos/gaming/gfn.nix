{
  config,
  pkgs,
  lib,
  ...
}: {
  options.gaming.gfn.enable = lib.mkEnableOption "Geforce now.";

  config = lib.mkIf (config.gaming.gfn.enable && pkgs.stdenv.isLinux) {
    environment.systemPackages = with pkgs; [
      gfn-electron
    ];
  };
}

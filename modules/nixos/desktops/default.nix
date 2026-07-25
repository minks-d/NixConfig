{
  lib,
  ...
}:
{
  options = {
    minksd.desktopEnv = lib.mkOption {
      type = lib.types.enum [
        "niri"
        "plasma"
      ];
    };
  };
  imports = [
    ./niri.nix
    ./plasma.nix
  ];
}

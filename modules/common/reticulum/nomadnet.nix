{
  inputs,
  pkgs,
  ...
}:
{
  config = {
    environment.systemPackages = [
      inputs.local-packages.packages.${pkgs.stdenv.hostPlatform.system}.nomadnet
    ];
  };
}

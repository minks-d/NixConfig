{
  inputs,
  globals,
  overlays,
  imports,
  system,
  ...
}:

inputs.nixpkgs.lib.nixosSystem {
  inherit system;

  specialArgs = {
  };

  modules =
    let
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs {inherit system overlays;};
    in
    imports
    ++ [
      inputs.home-manager.nixosModules.home-manager
      ../modules/common
      ../modules/nixos
      (
        { config, ... }:
        {
          config._module.args = {
            inherit inputs globals;
            upkgs = import inputs.nixpkgs {
              inherit overlays;
              system = "x86_64-linux";
            };
          };
        }
      )
      inputs.nixos-wsl.nixosModules.default
      {
        wsl = {
          enable = true;
          defaultUser = "minksd";
          docker-desktop.enable = true;
        };
        nixpkgs.overlays = overlays;
        system.stateVersion = "25.05";
        nix.settings.experimental-features = "flakes nix-command";

        networking.hostName = "minksdWSL";

        environment.systemPackages = with pkgs;[
        ];

        git.enable = true;
        zsh.enable = true;
        emacs.enable = true;
        nh.enable = true;
      }
    ];

}

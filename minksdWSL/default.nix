{
  inputs,
  globals,
  overlays,
  imports,
  ...
}:

inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    specialArgs = {
      inherit inputs globals;
      upkgs = import inputs.nixpkgs {inherit overlays; system = "x86_64-linux";};
    };

    modules = let system = "x86_64-linux"; in imports ++ [
     inputs.home-manager.nixosModules.home-manager
     ../modules/common
     ../modules/nixos
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
        
        git.enable = true;
        zsh.enable = true;
        emacs.enable = true;
        nh.enable = true;
      }
      ];
        
}

{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    kernel = {
      url = "https://raw.githubusercontent.com/NixOS/nixpkgs/refs/heads/master/pkgs/os-specific/linux/kernel/mainline.nix";
      flake = false;
    };
    wsl-config = {
      url = "https://raw.githubusercontent.com/microsoft/WSL2-Linux-Kernel/refs/heads/linux-msft-wsl-6.6.y/arch/x86/configs/config-wsl";
      flake = false;
    };
  };
  outputs = inputs:
    let
      system = "x86_64-linux";
      overlays = [
        (self: super: {
          linux_6_18_wsl = pkgs.linuxPackagesFor (pkgs.linuxKernel.kernels.linux_6_18.override {
            extraConfig = builtins.readFile inputs.wsl-config;
            ignoreConfigErrors = true;
          });
        })
      ];
      pkgs = import inputs.nixpkgs {inherit system overlays;};
    in {
      defaultPackage."${system}" = pkgs.linux_6_18_wsl.kernel;
    };
}

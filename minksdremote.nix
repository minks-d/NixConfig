{ globals, inputs, overlays,... }:

inputs.nixpkgs.lib.nixosSystem rec {
  system = "x86_64-linux";
  specialArgs = {
    pkgs = import inputs.nixpkgs{ inherit system overlays; config = { allowUnfree = true;};};
    upkgs = import inputs.nixpkgs-unstable { inherit system overlays; config = { allowUnfree = true;};};
  };
  modules =  [ 
    inputs.home-manager.nixosModules.home-manager
    ./modules/common
    ./modules/nixos
    rec {
      home-manager.backupFileExtension = "backup";
      nix.settings.experimental-features = "flakes nix-command"; 
      nixpkgs.overlays = overlays;
      networking.hostName = "minksdremote";
      networking.useNetworkd = true;

      fileSystems = {

        "/" = {
          device = "/dev/disk/by-label/NIXROOT";
          fsType = "ext4";
        };

        "/boot" = {

          device = "/dev/disk/by-label/NIXBOOT";
          fsType = "vfat";
        };
      };
      boot = {
        kernelPackages = specialArgs.upkgs.linuxKernel.packages.linux_6_10;
        initrd = {
          availableKernelModules = [
            "xhci_pci"
            "ahci"
            "usbhid"
            "sd_mod"
          ];
          kernelModules = [ ];
        };
        kernelModules = [ "kvm-intel" ];
        extraModulePackages = [ ];
        loader = {
	  efi.canTouchEfiVariables = true;
	  efi.efiSysMountPoint = "/boot";
          grub.enable = true;
	  grub.efiSupport = true;
	  grub.device = "nodev";
	  

        };
        
      };
      services = {
        pipewire = {
          enable = true;
          pulse.enable = true;
        };
        xserver = {
          enable = true;
        };
      };
      hardware = {
        cpu.intel.updateMicrocode = true;
        opengl.enable = true;
      };

      systemd.network = {
        enable = true;
        networks = {
          "01-enp6s18" = {
            matchConfig.Name = "enp6s18";
            networkConfig.DHCP = "ipv4";
            linkConfig.RequiredForOnline = "routable";
          };

        };
      };

      time.timeZone = "America/New_York";

      i18n.defaultLocale = "en_US.UTF-8";

      fonts.packages = with specialArgs.pkgs; [
            cascadia-code
      ];

      gui.enable = true;

      neovim.enable = true;
      firefox.enable = true;
      programs.zsh.enable = true;
      xterm.enable = true;

          }
  ];
}

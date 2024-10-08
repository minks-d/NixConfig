{ globals, inputs, overlays,... }:

inputs.nixpkgs.lib.nixosSystem rec {
  system = "x86_64-linux";
  specialArgs = {
    pkgs = import inputs.nixpkgs { inherit system overlays; config = { allowUnfree = true;};};
    upkgs = import inputs.nixpkgs-unstable { inherit system overlays; config = { allowUnfree = true;};};
  };
  modules = [ 
    inputs.home-manager.nixosModules.home-manager
    ./modules/common
    ./modules/nixos
    rec {
      home-manager.backupFileExtension = "backup";
      nix.settings.experimental-features = "flakes nix-command"; 
      nixpkgs.overlays = overlays;
      networking.hostName = "minksdHome";
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
          systemd-boot.enable = true;
	  systemd-boot.configurationLimit = 30;
        };
        swraid = {
          enable = true;
          mdadmConf = ''
          ARRAY /dev/md/NIXBOOT level=raid1 num-devices=2 metadata=0.90 UUID=955e248a:86cfc610:b859f0f2:1a8f29b7
          ARRAY /dev/md/NIXSWAP level=raid0 num-devices=2 metadata=1.2 UUID=52cfdedf:9349df8b:fc996bba:c4d0783c
          ARRAY /dev/md/NIXROOT level=raid0 num-devices=2 metadata=1.2 UUID=34277524:7d9ceb21:35ec9aec:1791a2
          MAILADDR danielminks1230@gmail.com
            			'';
        };
        extraModprobeConfig = ''
          blacklist nouveau
          options nouveau modeset=0
        '';
      };
      swapDevices = [ { device = "/dev/md/NIXSWAP"; } ];

      services = {
        pipewire = {
          enable = true;
          pulse.enable = true;
        };
        xserver = {
          enable = true;
          videoDrivers = [ "nvidia" ];
        };
      };
      hardware = {
        cpu.intel.updateMicrocode = true;
        nvidia = {
          package = boot.kernelPackages.nvidiaPackages.stable;
          modesetting.enable = true;
          powerManagement.enable = true;
          powerManagement.finegrained = false;
          open = false;
          nvidiaSettings = true;
        };
        opengl.enable = true;
      };

      systemd.network = {
        enable = true;
        networks = {
          "01-enp111s0" = {
            matchConfig.Name = "enp111s0";
            networkConfig.DHCP = "ipv4";
            linkConfig.RequiredForOnline = "routable";
          };

        };
      };

      time.timeZone = "America/New_York";

      i18n.defaultLocale = "en_US.UTF-8";

      fonts.packages = with specialArgs.pkgs; [
        (nerdfonts.override {
          fonts = [
            "CascadiaCode"
          ];
        })
      ];

      gui.enable = true;

      neovim.enable = true;
      firefox.enable = true;
      discord.enable = true;
      gaming = {
        enable = true;
        steam.enable = true;
      };
      programs.zsh.enable = true;

    }
  ];
}

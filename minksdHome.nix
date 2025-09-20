{
  globals,
  inputs,
  overlays,
  ...
}:
inputs.nixpkgs.lib.nixosSystem rec {
  system = "x86_64-linux";
  specialArgs = {
    inherit inputs;
    upkgs = import inputs.nixpkgs-unstable {
      inherit system overlays;
      config = {
        allowUnfree = true;
        #allowBroken = true;
      };
    };
  };
  modules = with specialArgs.upkgs; [
    inputs.home-manager.nixosModules.home-manager
    inputs.niri.nixosModules.niri
    ./modules/common
    ./modules/nixos
    rec {
      environment.systemPackages = with pkgs; [
        grayjay
        jetbrains.idea-ultimate
        unison
        vial
      ];
      system.stateVersion = "24.04";
      home-manager.backupFileExtension = "backup";
      nix.settings.experimental-features = "flakes nix-command";
      nixpkgs.overlays = overlays;
      nixpkgs.config.allowUnfree = true;
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
        "/steam" = {
          device = "/dev/disk/by-label/SteamGames";
          fsType = "ntfs-3g";
          options = ["rw" "nofail" "uid=3000" "blksize=65536"];
        };
      };
      boot = {
        supportedFilesystems = ["ntfs"];
        kernelPackages = specialArgs.upkgs.linuxPackages_latest; # or specialArgs.upkgs.linuxKernel.packages.linux_x_xx for specific kernel
        initrd = {
          availableKernelModules = [
            "xhci_pci"
            "ahci"
            "usbhid"
            "sd_mod"
          ];
          kernelModules = [];
        };
        kernelModules = ["nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" "i915"];
        extraModulePackages = [];
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
          options nvidia-drm modeset=1 fbdev=0
        '';
      };
      swapDevices = [{device = "/dev/md/NIXSWAP";}];

      #pipewire/wireplumber
      security.rtkit.enable = true;
      services = {
        #printing and avahi are both to enable network printing
        printing.enable = true;
        avahi = {
          enable = true;
          nssmdns4 = true;
          openFirewall = true;
        };
        
        mysql = {
          enable = true;
          package = pkgs.mariadb;
        };
        pipewire = {
          enable = true;
          pulse.enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          jack.enable = true;
        };

        udev.extraRules = ''
          KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
        '';
      };

      #nvidia/graphics
      services.xserver.videoDrivers = ["nvidia"];
      hardware = {
        cpu.intel.updateMicrocode = true;
        nvidia = {
          package = boot.kernelPackages.nvidiaPackages.latest;
          modesetting.enable = true;
          powerManagement.enable = true;
          powerManagement.finegrained = false;
          open = false;
          nvidiaSettings = true;
        };
        graphics.enable = true;
	graphics.enable32Bit = true;

      };

      xdg = {
        portal = {
          xdgOpenUsePortal = true;
          enable = true;
          extraPortals = with nixpkgs; [
            kdePackages.xdg-desktop-portal-kde
            xdg-desktop-portal
          ];
          config = {
            common.default = ["gtk"];
          };
        };
      };
      systemd.network = {
        enable = true;
        networks = {
          "01-enp111s0" = {
            enable = true;
            matchConfig.Name = "enp111s0";
            address = ["192.168.1.253/24"];
            gateway = ["192.168.1.1"];
            dns = ["1.1.1.1"];
            linkConfig.RequiredForOnline = "routable";
          };
        };
      };

      time.timeZone = "America/New_York";

      i18n.defaultLocale = "en_US.UTF-8";

      fonts.packages = with nixpkgs; [
        cascadia-code
        ipaexfont
      ];

      gui.enable = true;

      desktop.niri.enable = true;
      waybar.enable = true;
      foot.enable = true;
      zsh.enable = true;
      emacs.enable = true;
      firefox.enable = true;
      discord.enable = true;
      zoom.enable = true;
      elixir.enable = true;
      xterm.enable = true;
      flatpak.enable = true;
      teams.enable = true;
      steam.enable = true;
      lutris.enable = true;
      rust.enable = true;
        }
  ];
}

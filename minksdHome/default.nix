{
  system,
  globals,
  inputs,
  overlays,
  imports,
  ...
}:
let
  pkgs = import inputs.nixpkgs {
    inherit system overlays;
    config = {
      allowUnfree = true;
    };
  };
in
inputs.nixpkgs.lib.nixosSystem rec {
  inherit system;
  specialArgs = {
    inherit globals inputs;
    upkgs = import inputs.nixpkgs-unstable {
      inherit system overlays;
      config = {
        allowUnfree = true;
      };
    };
  };

  modules = imports ++ [
    ../modules/common
    ../modules/nixos
    ./boot.nix
    ./fs.nix
    ./dnscrypt-proxy.nix
    ./firewall.nix

    #Linux Kernel and nvidia drivers
    rec {
      boot.kernelPackages = specialArgs.upkgs.linuxPackages_latest; # or specialArgs.upkgs.linuxKernel.packages.linux_x_xx for specific kernel

      #nvidia/graphics
      hardware = {
        nvidia = {
          package = boot.kernelPackages.nvidiaPackages.vulkan_beta; # or vulkan_beta
          modesetting.enable = true;
          powerManagement.enable = true;
          powerManagement.finegrained = false;
          open = false;
          nvidiaSettings = true;
        };
        graphics.enable = true;
        graphics.enable32Bit = true;

      };
      services.xserver.videoDrivers = ["nvidia"];
      boot.kernelModules = [
        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];
            
    }

    #Other config
    {
      nixpkgs = {
        inherit overlays system;
        config = {
          allowUnfree = true;
          #allowBroken = true;
        };
      };

      time.timeZone = "America/New_York";
      i18n.defaultLocale = "en_US.UTF-8";

      environment = {
        systemPackages = builtins.attrValues {
          inherit (pkgs)
            unison
            vial
            ;
          inherit (pkgs.jetbrains)
            idea-ultimate
            rust-rover
            ;
        };
        variables = {
          EDITOR = "emacsclient";
          VISUAL = "emacsclient";
        };
      };
      system.stateVersion = "24.04";
      home-manager.backupFileExtension = "backup";
      nix.settings.experimental-features = "flakes nix-command";

      hardware.cpu.intel.updateMicrocode = true;

      virtualisation.docker.enable = true;
      virtualisation.podman.enable = true;

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

        pipewire = {
          enable = true;
          pulse.enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          jack.enable = true;
        };

        #For vial to access my cheapino
        udev.extraRules = ''
          KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
        '';
      };

      xdg = {
        portal = {
          xdgOpenUsePortal = true;
          enable = true;
          extraPortals = builtins.attrValues {
            inherit (pkgs)
              xdg-desktop-portal
              xdg-desktop-portal-gnome
              xdg-desktop-portal-gtk
              ;

          };
          config = {
            common.default = [ "gtk" ];
          };
        };
      };

      networking = {
        hostName = "minksdHome";
        enableIPv6 = true;
        useDHCP = true;
        dhcpcd.persistent = true;
        timeServers = [
          "time.nist.gov"
        ];
        
      };

      fonts.packages = builtins.attrValues {
        inherit (pkgs)
          cascadia-code
          ipaexfont
          ;
        inherit (pkgs.nerd-fonts)
          "m+"
          ;
      };

      gui.enable = true;

      tuned.enable = true;
      nh.enable = true;
      direnv.enable = true;
      desktop.niri.enable = true;
      noctalia.enable = true;
      foot.enable = true;
      zsh.enable = true;
      git.enable = true;
      emacs.enable = true;
      firefox.enable = true;
      discord.enable = true;
      flatpak.enable = true;
      teams.enable = true;
      steam.enable = true;
      lutris.enable = true;
      minecraft.enable = true;
    }
  ];
}

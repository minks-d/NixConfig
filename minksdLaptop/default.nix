{
  system,
  globals,
  inputs,
  overlays,
  imports,
  ...
}:
inputs.nixpkgs.lib.nixosSystem rec {
  inherit system;

  specialArgs = { };

  modules = imports ++ [
    ../modules/common
    ../modules/nixos
    ./firewall.nix
    ./hardware-configuration.nix
    ./noctalia.nix
    
    #Linux Kernel
    (
      { pkgs, ... }:
      {

        boot.kernelPackages = pkgs.linuxPackages_latest; # or pkgs.linuxKernel.packages.linux_x_xx for specific kernel

        hardware = {
          graphics.enable = true;
          graphics.enable32Bit = true;
          bluetooth.enable = true;
        };

      }
    )

    #Other config
    ({pkgs, ...}:{
      nixpkgs = {
        inherit overlays system;
        config = {
          allowUnfree = true;
          #allowBroken = true;
        };
      };

      nix.settings = {
        cores = 6;
        max-jobs = 2;
      };

      i18n.defaultLocale = "en_US.UTF-8";

      environment = {
        systemPackages = builtins.attrValues {
          inherit (pkgs)
            unison
            vial
          ;
          inherit (pkgs.jetbrains)
            idea
            rust-rover
          ;
        };
        variables = {
          EDITOR = "emacsclient";
          VISUAL = "emacsclient";
        };
      };
      system.stateVersion = "25.11";
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

        fwupd.enable = true;

        #For vial to access my cheapino
        udev.extraRules = ''
          KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
        '';
      };

      xdg = {
        portal = {
          enable = true;
          xdgOpenUsePortal = true;
          wlr.enable = true;
          extraPortals = builtins.attrValues {
            inherit (pkgs)
              xdg-desktop-portal
              xdg-desktop-portal-gnome
              xdg-desktop-portal-gtk
              xdg-desktop-portal-wlr
            ;

          };
          config = {
            common.default = [ "wlr" ];
          };
        };
      };

      networking = {
        networkmanager = {
          enable = true;
        };
        hostName = "minksdLaptop";
        enableIPv6 = true;
        dhcpcd.persistent = true;
        dhcpcd.extraConfig = ''
          noarp
          nodelay
        '';

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
      minecraft.enable = false;
      nh.enable = true;
      direnv.enable = true;
      desktop.niri.enable = true;
      noctalia.enable = true;
      alacritty.enable = true;
      zsh.enable = true;
      git.enable = true;
      emacs.enable = true;
      firefox.enable = true;
      discord.enable = true;
      flatpak.enable = true;
      teams.enable = true;
      steam.enable = true;
      lutris.enable = true;
      chrony.enable = true;
    })
  ];
}

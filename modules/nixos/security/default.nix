{pkgs, lib, config, ...}:{
  imports = [
    ./age.nix
    ./wrappers.nix
    ./modprobe.nix
    ./polkit.nix
  ];

  config = {
    
    security = {
      sudo.enable = false;
      
      pam.services = {
        login.u2fAuth = true;
        hyprlock = {
          u2fAuth = true;
          unixAuth = lib.mkForce true;
        };
      };

      #Sets the kernel's resource limit (ulimit -c 0)
      pam.loginLimits = [
        {
          domain = "*"; # Applies to all users/sessions
          type = "-"; # Set both soft and hard limits
          item = "core"; # The soft/hard limit item
          value = "0";   # Core dumps size is limited to 0 (effectively disabled)
        }
      ];
    };

    #agenix is currently bugged such that declarative users cant have their passwords loaded at runtime when using userborn
    #services.userborn.enable = true;

    #https://saylesss88.github.io/nix/hardening_NixOS.html#hardening-systemd
    systemd.coredump.enable = false;
    

    users.groups.netdev = {};
    services = {
      dbus.implementation = "broker";
      logrotate.enable = true;
      journald = {
        upload.enable = false; # Disable remote log upload (the default)
        extraConfig = ''
        SystemMaxUse=500M
        SystemMaxFileSize=50M
      '';
      };
    };
    
    # Only needed for WWAN/3G/4G modems, otherwise it runs `mmcli` unnecessarily
    networking.modemmanager.enable = false;
    # Bluetooth has a long history of vulnerabilities
    hardware.bluetooth.enable = false;
    # Prefer manual upgrades on a hardened system
    system.autoUpgrade.enable = false;


    boot.kernel.sysctl = {
      
      #IPv6 privacy extensions
      "net.ipv6.conf.all.use_tempaddr" = lib.mkForce 2;
      "net.ipv6.conf.default.use_tempaddr" = lib.mkForce 2;
    };
  };

}

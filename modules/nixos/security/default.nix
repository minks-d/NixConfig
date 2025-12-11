{pkgs, lib, config, ...}:{
  imports = [
    ./age.nix
    ./wrappers.nix
    ./modprobe.nix
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
      polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (subject.user == "minksd") {
            if (action.id.indexOf("org.nixos") == 0) {
              polkit.log("Caching admin authentication for single NixOS operation");
              return polkit.Result.AUTH_ADMIN_KEEP;
            }
          }
        });
      '';

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
    #Currently bugged such that declarative users cant have their passwords loaded at runtime
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

  };

}

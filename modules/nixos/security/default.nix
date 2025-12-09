{pkgs, lib, config, ...}:{
  imports = [
    ./age.nix
    ./wrappers.nix

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
    };    
    #Currently bugged such that declarative users cant have their passwords loaded at runtime
    #services.userborn.enable = true;
    
  };

}

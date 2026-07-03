{ pkgs, lib, ... }:
{
  config = {
    security.polkit = {
      enable = true;

      #No longer available, use extraArgs if needed.
      #debug = true;
      package = pkgs.polkit;

      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (subject.user == "minksd") {
            if (action.id.indexOf("org.nixos") == 0) {
              polkit.log("Caching admin authentication for single NixOS operation");
              return polkit.Result.AUTH_ADMIN_KEEP;
            }
          }
        });

        polkit.addRule(function(action, subject) {
          if (subject.user == "minksd") {
            polkit.log("Primary user auto pass");
            return polkit.Result.YES;
          }
          if (subject.isInGroup("wheel")) {
            polkit.log("Caching user authentication");
            return polkit.Result.AUTH_ADMIN_KEEP;
          }
        });
      '';
    };
  };
}

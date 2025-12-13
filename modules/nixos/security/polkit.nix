{ pkgs, lib, ... }:
{
  config = {
    security.polkit = {
      enable = true;
      debug = true;
      package = pkgs.polkit.overrideAttrs (
        final: prev: {
          src = pkgs.fetchFromGitHub {
            owner = "polkit-org";
            repo = "polkit";
            rev = lib.warn "Make sure that you follow up on polkit versions" "7c466c5";
            hash = "sha256-U3UoRpIT860MFxkGDOsFy+yLZ8FSTnTYYl8fclbYvYw=";
          };
          patches = [ ];
        }
      );

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
          if (subject.isInGroup("wheel")) {
            polkit.log("Caching user authentication");
            return polkit.Result.AUTH_ADMIN_KEEP;
          }
        });
      '';
    };
  };
}

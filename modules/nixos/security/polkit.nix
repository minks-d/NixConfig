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
            tag = lib.warn "Check Nixpkgs to see if pokit 127+ is published yet" "127";
            hash = "sha256-YTugETy0rqu/bv53jV1UeGqSK79bRXR52EJNcTblvzo=";
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

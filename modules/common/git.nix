{lib, config, pkgs, ...}:
{
  options = {
		git = {
			enable = lib.mkEnableOption {
				description = "Enable git.";
				default = true;
			};
		};
	};

	config = lib.mkIf (config.git.enable) {

    environment.systemPackages = builtins.attrValues {
      inherit (pkgs)
        git
        git-credential-oauth
        gh;
    };
    programs.git = {
      enable = true;
      config = [
        {
          credential = {
            helper = "cache --timeout 21600";
          };
        }
        {
          credential = {
            helper = "oauth";
          };
        }
      ];
    };
    
    home-manager.users.${config.user} = {
      programs.git = {
        enable = true;
        settings = {
          user = {
            name = "Daniel Minks";
            email = "danielminks1230@gmail.com";
          };
          
        };
      };
    };
  };
}

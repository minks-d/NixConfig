{
  config,
  pkgs,
  lib,
  ...
}:
{

  options = {

    passwordHash = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = "Password created with mkpasswd -m sha-512";
      default = null;
      # Test it by running: mkpasswd -m sha-512 --salt "PZYiMGmJIIHAepTM"
    };
  };

  config = {

    # Allows us to declaritively set password if false
    users.mutableUsers = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.minksd = {

      # Create a home directory for human user
      isNormalUser = true;

      # Automatically create a password to start
      hashedPassword = config.passwordHash;
      group = "minksd";
      extraGroups = [
        "wheel" # Sudo privileges
      ];
    };
    users.groups.minksd = {};

    # Allow writing custom scripts outside of Nix
    # Probably shouldn't make this a habit
    environment.localBinInPath = true;

    home-manager.users.minksd.xdg = {

      # Allow Nix to manage the default applications list
      mimeApps.enable = true;


      # Set directories for application defaults
      userDirs = {
        enable = true;
        createDirectories = true;
        documents = "$HOME/documents";
        download = config.userDirs.download;
        music = "$HOME/media/music";
        pictures = "$HOME/media/images";
        videos = "$HOME/media/videos";
        desktop = "$HOME/other/desktop";
        publicShare = "$HOME/other/public";
        templates = "$HOME/other/templates";
        extraConfig = {
          XDG_DEV_DIR = "$HOME/dev";
        };
      };
    };
  };
}

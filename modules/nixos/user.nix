{
  config,
  pkgs,
  lib,
  globals,
  inputs,
  ...
}:
{

  config = {

    # Allows us to declaritively set password if false
    users.mutableUsers = false;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.minksd = {

      # Create a home directory for human user
      isNormalUser = true;

      hashedPasswordFile = config.age.secrets.minksdPass.path;
      group = "minksd";
      extraGroups = [
        "wheel" # Sudo privileges
        "docker" # Allow access to the docker daemon
        "wireshark" # Allow this user to monitor network interfaces
      ];
    };
    users.groups.minksd = { };

    home-manager.users."${config.user}" = {

      imports = [
        inputs.agenix.homeManagerModules.default
      ];

      age.secrets.minksdU2F.file = "${globals.secretsDir}/minksdU2F.age";
      age.secrets.minksdU2F.path = "/home/minksd/.config/Yubico/u2f_keys";

      xdg = {

        # Allow Nix to manage the default applications list
        mimeApps.enable = true;

        # Set directories for application defaults
        userDirs = {
          enable = true;
          createDirectories = true;
          documents = "$HOME/documents";
          download = config.userDirs.download;
          extraConfig = {
            XDG_DEV_DIR = "$HOME/dev";
          };
        };
      };
    };
  };
}

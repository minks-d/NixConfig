{config,pkgs,lib,...}:
{
  options = {
    emacs = {
      enable = lib.mkEnableOption {
        description = "Enable emacs.";
        default = false;
      };
    };
  };
  config = lib.mkIf (config.emacs.enable == true) {
    environment.systemPackages = with pkgs;[
      emacs

      #Packages to install
      emacsPackages.nix-mode

    ];
    home-manager.users.${config.user} = {
      home.file.".emacs.el".source = ./init.el;
    };
  };
}

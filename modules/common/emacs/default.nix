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
      emacs.pkgs.nix-mode
      emacs.pkgs.lsp-mode
      emacs.pkgs.flycheck

    ];
    home-manager.users.${config.user} = {
      home.file.".emacs.d/init.el".source = ./init.el;
    };
  };
}

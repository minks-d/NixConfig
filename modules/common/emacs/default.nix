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
      emacs.pkgs.rust-mode
      emacs.pkgs.eglot
      

    ];
    home-manager.users.${config.user} = {
      home.file.".emacs.d/init.el".source = ./init.el;
      home.file.".emacs.d/rust.el".source = ./rust.el;
      home.file.".emacs.d/elixir.el".source = ./elixir.el;
      
    };
  };
}

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
    services.emacs = {
      enable = true;
      package = let epkgs = pkgs.epkgs; in (
        (pkgs.emacsPackagesFor pkgs.emacs-pgtk).emacsWithPackages (
          epkgs: builtins.attrValues {
            inherit (epkgs)
              nix-mode
              lsp-mode
              flycheck
              rust-mode
              eglot;
          }
        )
      );
      startWithGraphical = true;
      install = true;
    };

    home-manager.users.${config.user} = {
      home.file.".emacs.d/init.el".source = ./init.el;
      home.file.".emacs.d/rust.el".source = ./rust.el;
      home.file.".emacs.d/elixir.el".source = ./elixir.el;
      
    };
  };
}

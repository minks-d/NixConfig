{
  config,
  pkgs,
  lib,
  ...
}:
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
    environment.systemPackages = [
      pkgs.rust-analyzer
    ];
    services.emacs = {
      enable = true;
      package =
        let
          epkgs = pkgs.epkgs;
        in
        ((pkgs.emacsPackagesFor pkgs.emacs-pgtk).emacsWithPackages (
          epkgs:
          builtins.attrValues {
            inherit (epkgs)
              projectile
              helm-projectile
              flycheck
              eglot
              company
              nix-mode
              lsp-mode
              rust-mode
              elixir-mode
              ;
          }
        ));
      startWithGraphical = false;
      install = true;
    };

    home-manager.users.${config.user} = {
      home.file.".emacs.d/init.el".source = ./init.el;
      home.file.".emacs.d/rust.el".source = ./rust.el;
      home.file.".emacs.d/elixir.el".source = ./elixir.el;

    };
  };
}

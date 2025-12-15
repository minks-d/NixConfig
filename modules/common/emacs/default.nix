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
              nixd
              lsp-mode
              lsp-java
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
    };
  };
  imports = [
    ./java.nix
    ./elixir.nix
    ./rust.nix
    ./nix.nix
  ];
}

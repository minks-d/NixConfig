{
  pkgs,
  github ? false,
  ...
}:

pkgs.neovimBuilder {
  package = pkgs.neovim-unwrapped;
  inherit github;
  imports = [ ./config/lsp.nix ];
}

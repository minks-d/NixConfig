{
  config,
  pkgs,
  lib,
  ...
}:

let

  neovim = import ./package {
    inherit pkgs;
    github = true;
  };
in
{

  options.neovim.enable = lib.mkEnableOption "Neovim.";

  config = lib.mkIf config.neovim.enable {
    home-manager.users.${config.user} =

      {

        home.packages = [ neovim ];

        # Use Neovim as the editor for git commit messages
        programs.git.extraConfig.core.editor = "nvim";

        # Set Neovim as the default app for text editing and manual pages
        home.sessionVariables = {
          EDITOR = "nvim";
          MANPAGER = "nvim +Man!";
        };

        # Create quick aliases for launching Neovim
        programs.zsh = {
          shellAliases = {
            vim = "nvim";
          };
                  };

        # Create a desktop option for launching Neovim from a file manager
        # (Requires launching the terminal and then executing Neovim)
        xdg.desktopEntries.nvim = lib.mkIf pkgs.stdenv.isLinux {
          name = "Neovim wrapper";
          exec = "xterm nvim %F";
          mimeType = [
            "text/plain"
            "text/markdown"
          ];
        };
        xdg.mimeApps.defaultApplications = lib.mkIf pkgs.stdenv.isLinux {
          "text/plain" = [ "nvim.desktop" ];
          "text/markdown" = [ "nvim.desktop" ];
        };
      };
  };
}
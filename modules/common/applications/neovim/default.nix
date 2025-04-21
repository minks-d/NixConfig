{
  config,
  pkgs,
  lib,
  ...
}: {
  options.neovim.enable = lib.mkEnableOption "Neovim.";

  config = lib.mkIf config.neovim.enable {
    environment.systemPackages = with pkgs; [
      #Code formatters
      nil
      alejandra
      stylua

      #Search functionalities
      ripgrep
      fd
      #LSPs
      clang-tools #C,C++
      jdt-language-server #Java
    ];
    home-manager.users.${config.user} = {config, ...}: {
      programs.neovim.enable = true;
      programs.neovim.extraLuaConfig = ''
        vim.opt.scrolloff = 15
        vim.opt.number = true
        vim.opt.relativenumber = true
        require'lspconfig'.nil_ls.setup{}

        vim.opt.completeopt=menu,menuone,noselect
        ${builtins.readFile ./lua/cmp.lua}
        ${builtins.readFile ./lua/conform.lua}
        ${builtins.readFile ./lua/telescope.lua}
        ${builtins.readFile ./lua/nvim-lspconfig.lua}



      '';
      programs.neovim.plugins = with pkgs.vimPlugins; [
        nvim-cmp
        #plugins for nvim-cmp
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        cmp-cmdline

        nvim-lspconfig
        nvim-treesitter
        conform-nvim
        telescope-nvim
      ];

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
    };
  };
}

{
  pkgs,
  lib,
  config,
  dsl,
  ...
}:
{

  options.github = lib.mkEnableOption "Whether to enable GitHub features";

  config = {
    plugins = [
      pkgs.vimPlugins.nvim-lspconfig
      pkgs.vimPlugins.nvim-lint
    ];

    use.lspconfig.lua_ls.setup = dsl.callWith {
      settings = {
        Lua = {
          diagnostics = {
            globals = [
              "vim"
              "hs"
            ];
          };
        };
      };
      capabilities = dsl.rawLua "require('cmp_nvim_lsp').default_capabilities()";
      cmd = [ "${pkgs.lua-language-server}/bin/lua-language-server" ];
    };

    use.lspconfig.nixd.setup = dsl.callWith {
      cmd = [ "${pkgs.nixd}/bin/nixd" ];
      capabilities = dsl.rawLua "require('cmp_nvim_lsp').default_capabilities()";
    };

    use.lspconfig.rust_analyzer.setup = dsl.callWith {
      cmd = [ "${pkgs.rust-analyzer}/bin/rust-analyzer" ];
      settings = {
        "['rust-analyzer']" = {
          check = {
            command = "clippy";
          };
          files = {
            excludeDirs = [ ".direnv" ];
          };
          cargo = {
            features = "all";
          };
        };
      };
    };
    use.lint = {
      linters_by_ft = dsl.toTable {
        sh = [ "shellcheck" ];
      };
    };

    vim.api.nvim_create_autocmd = dsl.callWith [
      (dsl.toTable [
        "BufEnter"
        "BufWritePost"
      ])
      (dsl.rawLua "{ callback = function() require('lint').try_lint() end }")
    ];

    lua = ''
      ${builtins.readFile ./lsp.lua}

      local ruff = require('lint').linters.ruff; ruff.cmd = "${pkgs.ruff}/bin/ruff"
      local shellcheck = require('lint').linters.shellcheck; shellcheck.cmd = "${pkgs.shellcheck}/bin/shellcheck"

      -- Prevent infinite log size (change this when debugging)
      vim.lsp.set_log_level("off")

      -- Hide buffer diagnostics (use tiny-inline-diagnostic.nvim instead)
      vim.diagnostic.config({ virtual_text = false })
    '';
  };
}

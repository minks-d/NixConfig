local conform = require("conform")

conform.setup({

	formatters_by_ft = {
		lua = { "stylua" },
		-- Conform will run multiple formatters sequentially
		nix = { "alejandra" },
		c = { clang - formate },
	},

	-- Set this to change the default values when calling conform.format()
	-- This will also affect the default values for format_on_save/format_after_save
	default_format_opts = {
		lsp_format = "fallback",
	},
	notify_on_error = true,

	-- Set the log level. Use `:ConformInfo` to see the location of the log file.
	--log_level = vim.log.levels.DEBUG,
	-- Conform will notify you when a formatter errors
	notify_on_error = true,
	-- Conform will notify you when no formatters are available for the buffer
	notify_no_formatters = true,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

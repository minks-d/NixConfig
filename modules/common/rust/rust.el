(require 'rust-mode)

;;Enables lsp client when editing a rust file
(add-hook 'rust-mode-hook #'lsp)

;;Formats file when saved
(setq rust-format-on-save t)

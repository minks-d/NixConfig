;;; -*- lexical-binding: t -*-
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(tsdh-dark)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;------Package Management-----


;;------Setting variables------

;;Disable the startup screen
(setq inhibit-startup-screen t)
;;Move all backups to ~/.ebackups
(setq backup-directory-alist '(("." . "~/.backups")))
;;Delete autosave files after buffer is closed
(setq kill-buffer-delete-auto-save-files 1)
(setq delete-auto-save-files t)

;;------Programming------

;;Eglot + Configuration
(use-package eglot)
(add-hook 'elixir-mode-hook 'eglot-ensure)
(add-to-list 'eglot-server-programs `(elixir-mode (concat (getenv "ELIXIR_LS_PATH") "/release/language_server.sh")))

;;Enable lsp-mode globally, installed in ./default.nix
	     (use-package lsp-mode
	       :commands lsp
	       :diminish lsp-mode
	       :hook
	       (elixir-mode . lsp)
	       :init
	       (add-to-list 'exec-path (concat (getenv "ELIXIR_LS_PATH") "/release"))
	      )

;;Rust Configuration
(load "~/.emacs.d/rust.el")

;;Elixir Configuration
(load "~/.emacs.d/elixir.el")

;;Enable the nix-mode package, installed in ./default.nix
(use-package nix-mode
  :mode "\\.nix\\'")

;;Adds flycheck for inline syntax checking
(use-package flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)

(provide 'init)
;;;

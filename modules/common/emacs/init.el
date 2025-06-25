;;; init.el --- initialization of emacs configuration -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
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


;;------Setting variables------

;;Disable the startup screen
(setq inhibit-startup-screen t)
;;Move all backups to ~/.ebackups
(setq backup-directory-alist '(("." . "~/.backups")))
;;Delete autosave files after buffer is closed
(setq kill-buffer-delete-auto-save-files 1)
(setq delete-auto-save-files nil)

;;------Programming------

;;Enable lsp-mode globally, installed in ./default.nix
(use-package lsp-mode)
;;Adds flycheck for inline syntax checking
(use-package flycheck
  :after lsp-mode
  :hook (after-init . global-flycheck-mode)
  :custom (flycheck-emacs-lisp-load-path 'inherit))
;;Enable lsp-ui for integration with flycheck
(use-package lsp-ui
  :after flycheck)
;;Enable the nix-mode package, installed in ./default.nix
(use-package nix-mode
  :mode "\\.nix\\'")
;;Rust Configuration
(load "~/.emacs.d/rust.el")

(provide 'init)
;;; init.el ends here

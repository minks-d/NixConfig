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

;;helm-projectile
(use-package projectile
  :init (setq projectile-project-search-path '("~/projects/" "~/nixos" "~/nixpkgs")))
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(projectile-mode +1)

(use-package helm-projectile)
(helm-projectile-on)

;;company-mode
(use-package company)
(add-hook 'after-init-hook 'global-company-mode)


;;Rust Configuration
(load "~/.emacs.d/rust.el")

;;Elixir Configuration
(load "~/.emacs.d/elixir.el")

;;Java Configuration
(load "~/.emacs.d/java.el")

;;Nix Configuration
(load "~/.emacs.d/nix.el")

;;Adds flycheck for inline syntax checking
(use-package flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)

(provide 'init)
;;;

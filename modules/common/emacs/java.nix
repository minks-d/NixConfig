{config, pkgs, ...}:{
  config = {
    environment.systemPackages = [
      pkgs.jdt-language-server
      pkgs.jdk
    ];

    home-manager.users.${config.user} = {
      home.file.".emacs.d/java.el".text = ''
      ;;; -*- lexical-binding: t -*-
      ;;; Code:
      (use-package lsp-java
        :config (add-hook 'java-mode-hook 'lsp)
                (setq lsp-java-server-install-dir "${pkgs.jdt-language-server}/")
                (setq lsp-java-java-path "${pkgs.jdk}/bin/"))
      '';
    };
  };
}

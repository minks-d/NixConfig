{ config, pkgs, ... }:
{
  config = {
    environment.systemPackages = [
      pkgs.jdt-language-server
      pkgs.jdk
    ];

    home-manager.users.${config.user} = {
      home.file.".emacs.d/java.el".text = ''
      (use-package lsp-java
        :config (setq lsp-java-java-path "${pkgs.jdk}/bin/java"))
      '';
    };
  };
}

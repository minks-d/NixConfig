{config, pkgs, lib, ...}:{
  config = {
    environment.systemPackages = [
      pkgs.nixd
    ];
    home-manager.users.${config.user} = {
      home.file.".emacs.d/nix.el".text = ''
    (use-package nix-mode
      :mode "\\.nix\\'")

    '';
    };
  };
}

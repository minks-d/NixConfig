{config, ...}:{
  config = {
    home-manager.users.${config.user} = {
      home.file.".emacs.d/elixir.el".text = ''
      (use-package elixir-mode)
      '';
    };
  };


}

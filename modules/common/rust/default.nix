{config,inputs,upkgs,lib,...}:
{
  options = {
    rust = {
      enable = lib.mkEnableOption {
        description = "Setup rust and its components.";
        default = false;
      };
    };
  };

  config = lib.mkIf (config.rust.enable) {
    environment.systemPackages = with upkgs; [
      rust-analyzer-nightly

      emacs.pkgs.rust-mode
      
    ];

    home-manager.users.${config.user} = {
      home.file.".emacs.d/rust.el".source = ./rust.el;
    };
  };
      

}

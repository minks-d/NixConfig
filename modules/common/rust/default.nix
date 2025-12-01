{config, pkgs, lib,...}:
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
    environment.systemPackages = [
        pkgs.rust-analyzer-nightly
#        pkgs.rust-bin.selectLatestNightlyWith (toolchain: toolchain.default)
    ];
  };
      

}

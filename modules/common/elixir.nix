{pkgs, lib, config, ...}:

{
	options = {
    elixir = {
      enable = lib.mkEnableOption {
        description = "Enable Elixir.";
        default = false;
      };
    };
  };

  config = lib.mkIf (config.elixir.enable) {
    environment.systemPackages = [ pkgs.elixir ];
    };


}

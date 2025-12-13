{
  pkgs,
  lib,
  config,
  ...
}:

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
    environment.systemPackages = with pkgs; [
      elixir
      erlang
      beam27Packages.elixir-ls
    ];
    environment.sessionVariables = with pkgs; {
      ELIXIR_LS_PATH = "${beam27Packages.elixir-ls}";
    };
  };

}

{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    firefox = {
      enable = lib.mkEnableOption {
        description = "Enable Firefox.";
        default = false;
      };
    };
  };

  config = lib.mkIf (config.gui.enable && config.firefox.enable) {
    home-manager.users.${config.user} = {
      programs.firefox = {
        enable = true;
        package =
          if pkgs.stdenv.isDarwin
          then pkgs.firefox-bin
          else pkgs.firefox;
        profiles.default = {
          id = 0;
          name = "default";
          isDefault = true;
          extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
            sidebery
          ];
          settings = {
            "app.update.auto" = false;
            "browser.aboutConfig.showWarning" = false;
            "media.ffmpeg.vaapi.enabled" = true;
            "svg.context-properties.content.enabled" = true;
          };
        };
      };
      xdg.mimeApps = {
        associations.added = {
          "text/html" = ["firefox.desktop"];
        };
        defaultApplications = {
          "text/html" = ["firefox.desktop"];
        };
        associations.removed = {
          "text/html" = ["wine-extension-htm.desktop"];
        };
      };
    };
  };
}

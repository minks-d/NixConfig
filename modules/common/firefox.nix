{
  lib,
  config,
  pkgs,
  upkgs,
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
    services.i2p.enable = true;
    
    home-manager.users.${config.user} = {
      programs.firefox =
        let
          genericSettings = {
            "app.update.auto" = false;
            "browser.aboutConfig.showWarning" = false;
            "media.ffmpeg.vaapi.enabled" = true;
            "svg.context-properties.content.enabled" = true;
            "fission.autostart" = true;
            "gfx.webrender.all" = true;
          };
        in {
        enable = true;
        package = upkgs.firefox;

        profiles.default = {
          id = 0;
          name = "default";
          isDefault = true;
          extensions.packages = builtins.attrValues {
            inherit (upkgs.nur.repos.rycee.firefox-addons)
              sidebery;
          };
          settings = {
          } // genericSettings;
        };
        profiles."i2p" = {
          id = 1;
          name = "i2p";
          isDefault = false;
          settings = {
            "network.proxy.type" = 1;
            "network.proxy.http" = "[::ffff:127.0.0.1]";
            "network.proxy.http_port" = 4444;
            "network.proxy.ssl" = "[::ffff:127.0.0.1]";
            "network.proxy.ssl_port" = 4444;
            "network.proxy.no_proxies_on" = "[::ffff:127.0.0.1], 127.0.0.1, localhost";
            "media.peerconnection.ice.proxy_only" = true;
            "keyword.enabled" = false;
          } // genericSettings;
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

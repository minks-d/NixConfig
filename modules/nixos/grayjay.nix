{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    grayjay = {
      enable = lib.mkEnableOption {
        description = "Enable grayjay.";
        default = false;
      };
    };
  };

  config = lib.mkIf (config.gui.enable && config.grayjay.enable) {
    environment.systemPackages = [
      (pkgs.buildFHSUserEnv {
        name = "grayjay";
        targetPkgs = _:
          with pkgs; [
            libz
            icu
            openssl # For updater

            xorg.libX11
            xorg.libXcomposite
            xorg.libXdamage
            xorg.libXext
            xorg.libXfixes
            xorg.libXrandr
            xorg.libxcb

            gtk3
            glib
            nss
            nspr
            dbus
            atk
            cups
            libdrm
            expat
            libxkbcommon
            pango
            cairo
            udev
            alsa-lib
            mesa
            libGL
            libsecret
          ];
      })
      .env
    ];
  };
}

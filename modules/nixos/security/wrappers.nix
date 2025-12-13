{
  pkgs,
  lib,
  config,
  ...
}:
{

  config =
    let
      noSuidWrappers = {
        su = { };
        sudoedit = { };
        sg = { };
        mount = { };
        umount = { };
        pkexec = { };
        newgrp = { };
        newgidmap = { };
        newuidmap = { };
        chsh = { };
      };
      exceptions = {
        mount = "${lib.getBin pkgs.util-linux}/bin/mount";
        umount = "${lib.getBin pkgs.util-linux}/bin/umount";
        chsh = "${lib.getBin pkgs.util-linux}/bin/chsh";
        sudo = "${lib.getBin pkgs.sudo}/bin/sudo";
        sudoedit = "${lib.getBin pkgs.sudo}/bin/sudoedit";
        pkexec = "${lib.getBin pkgs.polkit}/bin/pkexec";
      };
      cfg = config.security.wrappers;
    in
    {
      security.wrappers = lib.mapAttrs (name: value: {
        setuid = lib.mkForce false;
        source =
          if (value ? source) then lib.mkDefault value.source else lib.mkDefault exceptions."${name}";
        owner = lib.mkDefault "root";
        group = lib.mkDefault "root";
      }) noSuidWrappers;
    };

}

{ pkgs, ... }:

{

  fileSystems = {

    "/" = {
      device = "/dev/disk/by-label/NIXROOT";
      fsType = "ext4";
    };

    "/boot" = {

      device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
    };
  };
}

{ ... }:
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
    "/steam" = {
      device = "/dev/disk/by-uuid/256011a9-7c27-4596-b7de-b4c3f6106532";
      fsType = "btrfs";
      options = [
        "compress=zstd:3"
        "noatime"
        "nofail"
      ];
    };
  };
  swapDevices = [ { device = "/dev/md/NIXSWAP"; } ];

}

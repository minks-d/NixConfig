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
      device = "/dev/disk/by-label/SteamGames";
      fsType = "ntfs-3g";
      options = [
        "rw"
        "nofail"
        "uid=3000"
        "blksize=65536"
      ];
    };
  };
  swapDevices = [ { device = "/dev/md/NIXSWAP"; } ];

}

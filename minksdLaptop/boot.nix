{ ... }:
{
  boot = {
    tmp = {
      useTmpfs = true;
      tmpfsSize = "10%";
      tmpfsHugeMemoryPages = "within_size";
      cleanOnBoot = true;
    };
    supportedFilesystems = [ "ntfs" ];

  };
}

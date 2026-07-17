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
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "usbhid"
        "sd_mod"
      ];
      kernelModules = [ ];
    };
    kernelModules = [
      "i915"
    ];
    kernelParams = [
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
      "nvidia.NVreg_EnableGpuFirmware=0"
    ];
    extraModulePackages = [ ];
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 30;
    };
    kernel.sysctl = {
      "vm.swappiness" = 20;
    };
    swraid = {
      enable = true;
      mdadmConf = ''
        ARRAY /dev/md/NIXBOOT level=raid1 num-devices=2 metadata=0.90 UUID=955e248a:86cfc610:b859f0f2:1a8f29b7
        ARRAY /dev/md/NIXSWAP level=raid0 num-devices=2 metadata=1.2 UUID=52cfdedf:9349df8b:fc996bba:c4d0783c
        ARRAY /dev/md/NIXROOT level=raid0 num-devices=2 metadata=1.2 UUID=34277524:7d9ceb21:35ec9aec:1791a2
        MAILADDR danielminks1230@gmail.com
      '';
    };
  };

}

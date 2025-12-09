{pkgs, lib, config, ...}:{

  options.chrony.enable = lib.mkEnableOption {default = false;};

  config = {
    time.timeZone = "America/New_York";
    chrony.enable = false;
    networking.timeServers = lib.mkIf (!config.chrony.enable) [ "time.nist.gov" ];
    services.chrony = lib.mkIf (config.chrony.enable) {
      enable = true;
      enableNTS = true;
      serverOption = "iburst";
      extraConfig = ''
        server time.cloudflare.com iburst nts key 1
        server ntp1.glypnod.com iburst nts key 2
        server nts.netnod.se iburst nts key 3
        server ntppool1.time.nl iburst nts key 4
        server ntp.nanosrvr.cloud iburst nts key 1
        pool 0.ke.experimental.ntspooltest.org iburst nts key 2
        pool 1.ke.experimental.ntspooltest.org iburst nts key 3
        pool 2.ke.experimental.ntspooltest.org iburst nts key 4
        pool 3.ke.experimental.ntspooltest.org iburst nts key 1

        driftfile /var/lib/chrony/drift
        dumpdir /var/lib/chrony
        ntsdumpdir /var/lib/chrony

        keyfile /var/lib/chrony/chrony.keys

        minsources 5

        makestep 1.0 3

      '';
      
    };
  };
}

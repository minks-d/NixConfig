{pkgs, lib, config, ...}:{

  config = {
    containers.i2pd-container = {

      autoStart = true;
      config = { ... }: {
        services.i2pd = {
          enable = true;
          enableIPv6 = true;
          address = "::1";
          proto = {
            http = {
              enable = true;
              address = "::1";
              strictHeaders = false;
            };
            socksProxy.enable = true;
            socksProxy.address = "::1";
            httpProxy.enable = true;
            httpProxy.address = "::1";
            i2cp.enable = true;
            i2pControl.enable = true;
          };
        };
        networking.firewall = {
          enable = true;
          allowedTCPPorts = [
            7070 # default web interface port
            4447 # default socks proxy port
            4444 # default http proxy port
          ];
        };
        system.stateVersion = "25.11"; # If you don't add a state version, nix will complain at every rebuild
      };
    };
  };
}

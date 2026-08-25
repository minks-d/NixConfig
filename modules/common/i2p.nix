{
  pkgs,
  lib,
  config,
  ...
}:
{

  config = {
    containers.i2pd-container = {

      autoStart = true;
      config =
        { ... }:
        {
          services.i2pd = {
            enable = true;
            settings = {
              address6 = "::1";
              ipv6 = true;
              http = {
                enabled = true;
                address = "::1";
                strictheaders = false;
              };
              socksproxy= {
                enabled = true;
                address = "::1";
              };
              httpproxy = {
                enabled = true;
                address = "::1";
              };
              i2cp.enabled = true;
              i2pcontrol.enabled = true;
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

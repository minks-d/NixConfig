{
  inputs,
  pkgs,
  lib,
  ...
}:

let
  blocklist_base = builtins.readFile inputs.oisd;
  extraBlocklist = '''';
  blocklist_txt = pkgs.writeText "blocklist.txt" ''
    ${extraBlocklist}
    ${blocklist_base}
  '';
  hasIPv6Internet = true;
  StateDirectory = "dnscrypt-proxy";
in
{
  # See https://wiki.nixos.org/wiki/Encrypted_DNS

  networking.nameservers = [
    "::1"
    "127.0.0.1"
  ];
  networking.networkmanager.dns = "none";

  services.resolved.enable = lib.mkForce false;

  systemd.services.dnscrypt-proxy.wantedBy = [ "network-online.target" ]; # So that other services that need network can get dns
  services.dnscrypt-proxy = {
    enable = true;

    # See https://github.com/DNSCrypt/dnscrypt-proxy/blob/master/dnscrypt-proxy/example-dnscrypt-proxy.toml
    settings = {

      bootstrap_resolvers = [
        "1.1.1.1:53"
        "8.8.8.8:53"
        "9.9.9.11:53"
      ];
      sources.odoh-servers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/odoh-servers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/odoh-servers.md"
        ];
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        cache_file = "/var/lib/${StateDirectory}/odoh-servers.md";
        refresh_delay = 73;
        prefix = "";
      };
      sources.odoh-relays = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/odoh-relays.md"
          "https://download.dnscrypt.info/resolvers-list/v3/odoh-relays.md"
        ];
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        cache_file = "/var/lib/${StateDirectory}/odoh-relays.md";
        refresh_delay = 73;
        prefix = "";
      };

      anonymized_dns = {
        routes = [
          {
            server_name = "*";
            via = [ "*" ];
          }
        ];
      };

      # Use servers reachable over IPv6 -- Do not enable if you don't have IPv6 connectivity
      ipv6_servers = hasIPv6Internet;
      block_ipv6 = !(hasIPv6Internet);

      odoh_servers = true;
      require_dnssec = true;
      require_nolog = false;
      require_nofilter = true;

      http3 = true;

      listen_addresses = [ "127.0.0.1:53" ] ++ (if (hasIPv6Internet) then [ "[::1]:53" ] else [ ]);
      blocked_names.blocked_names_file = blocklist_txt;

      # If you want, choose a specific set of servers that come from your sources.
      # Here it's from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
      # If you don't specify any, dnscrypt-proxy will automatically rank servers
      # that match your criteria and choose the best one.
      # server_names = [ ... ];
    };
  };

  systemd.services.dnscrypt-proxy.serviceConfig.StateDirectory = StateDirectory;

  networking.nftables = {
    enable = true;

    ruleset = ''
      table inet filter {
        chain output {
          type filter hook output priority 0; policy accept;

          # Allow localhost DNS for dnscrypt-proxy
          ip daddr 127.0.0.1 udp dport 53 accept
          ip6 daddr ::1 udp dport 53 accept
          ip daddr 127.0.0.1 tcp dport 53 accept
          ip6 daddr ::1 tcp dport 53 accept

          # Allow dnscrypt-proxy to talk to upstream servers
          # Replace <DNSCRYPT-UID> with:
          # ps -o uid,user,pid,cmd -C dnscrypt-proxy
          meta skuid 62582 udp dport { 53, 443, 853 } accept
          meta skuid 62582 tcp dport { 53, 443, 853 } accept

          # Block all other outbound DNS
          udp dport { 53, 853 } drop
          tcp dport { 53, 853 } drop
        }
      }
    '';
  };
}

{ ... }:
{

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      # Ports open for inbound connections.
      # Limit these to reduce the attack surface.

      22
      # SSH - Keep open only if you need remote access.
      # To change the SSH port in NixOS:
      # services.openssh.ports = [ 2222 ];
      # Update this list to match the new port.

      # 53  # DNS - Only if running a public DNS server.
      # 80  # HTTP - Only if hosting a website.
      # 443 # HTTPS - Only if hosting a secure website.
    ];
    allowedUDPPorts = [
      # Ports open for inbound UDP traffic.
      # Most NixOS workstations won't need any here.

      # 53 # DNS - Only if running a public DNS server.
    ];
  };
}

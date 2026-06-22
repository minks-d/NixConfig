{config,...}:
{
  config.services.rnsd = {
    enable = true;
    settings = {
      reticulum = {
        discover_interfaces = true;
        autoconnect_discovered_interfaces = 16;
        enable_transport = false;
        share_instance = true;
        instance_name = "default";
      };
      interfaces = [
        {
          enabled = true;
          type = "TCPClientInterface";
          name = "DefaultInterface";
          additionalSettings = {
            target_host = "mia.us.thunderhost.net";
            target_port = "4242";
          };
        }
      ];
    };
  };
}

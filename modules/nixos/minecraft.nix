{
  config,
  pkgs,
  lib,
  ...
}:

{
    options = {
      minecraft = {
            enable = lib.mkEnableOption {
              description = "Enable Olivia MC server.";
            };
          };
  };

  config = lib.mkIf config.minecraft.enable {
  # Minecraft server settings
  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    servers.fabric = {
      enable = true;

      jvmOpts = "-Xms2048M -Xmx4096M";
      # Specify the custom minecraft server package
      package = pkgs.fabricServers.fabric-1_21_10.override {
        loaderVersion = "0.18.0";
      }; # Specific fabric loader version

      files = {
        "config/Geyser-Fabric/config.yml".value = {
          bedrock = {
            address = "192.168.1.253";
          };
          port = 19131;
        };
      };
      
      symlinks = {
        mods = pkgs.linkFarmFromDrvs "mods" (
          builtins.attrValues {
            Fabric-API = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/dQ3p80zK/fabric-api-0.138.3%2B1.21.10.jar";
              sha256 = "sha256-rCB1kEGet1BZqpn+FjliQEHB1v0Ii6Fudi5dfs9jOVM=";
            };
            AppleSkin = pkgs.fetchurl {
               url = "https://cdn.modrinth.com/data/EsAfCjCV/versions/8sbiz1lS/appleskin-fabric-mc1.21.9-3.0.7.jar";
               sha256 = "sha256-ejEbFTr0wrdgm4SSpjsk3Zt6/TOLrBoj32qJGm6AC4k=";
            };
#            Inventory-Essentials = pkgs.fetchurl {
#              url = "https://cdn.modrinth.com/data/Boon8xwi/versions/uHseJiGy/inventoryessentials-fabric-1.21.10-21.10.3.jar";
#              sha256 = "sha256-ShKTqsda8ZaCeoxFtXqzTeeDejll9oin16E+VcJPA58=";
#            };
          }
        );
      };
    };
  };
  };
}

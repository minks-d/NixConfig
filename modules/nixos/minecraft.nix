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
            Geyser-MC = pkgs.fetchurl {
              url = "https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/fabric";
              sha256 = "sha256-Ut1H+NI34jNjkCWS7LPgPVK1gv/WO9dWgP7kthkWVN0=";
            };
          }
        );
        "config/Geyser-Fabric/config.yml".value = {
          bedrock = {
            address = "0.0.0.0";
            port = 19132;
          };
        };
      };
    };
  };
  };
}

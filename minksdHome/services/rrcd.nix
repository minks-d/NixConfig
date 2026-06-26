{
  lib,
  ...
}:
{
  config.services.rrcd = {
    enable = true;
    rrcd = {
      hub = {
        hub_name = "USEAST Central Florida RRC Hub";
        greeting = "A hub for the Central Florida Region, though all are welcome such that the community can grow and improve. #general";
        trusted_identities = [ "1dec8ed96c4b45169a9d239eb8c13332" ];
      };
    };
  };
}

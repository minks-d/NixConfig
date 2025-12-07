{pkgs, lib, config, inputs, globals, system,...}:{

  config = {
    environment.systemPackages = [
      inputs.agenix.packages."${pkgs.system}".default
    ];
    services.openssh = {
      enable = true;
    };

    age = {
      secrets = {
        minksdPass.file = "${globals.secretsDir}/minksdPass.age";
      };
    };
  };

}

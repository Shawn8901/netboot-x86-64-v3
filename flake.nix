{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";
  };

  outputs = inputs: {
    nixosConfigurations.netboot = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        {
          nixpkgs.hostPlatform = {
            system = "x86_64-linux";
            gcc.arch = "x86-64-v3";
          };
        }
        {
          imports = [ "${inputs.nixpkgs.outPath}/nixos/modules/installer/netboot/netboot-base.nix" ];
        }
      ];
    };
    hydraJobs = {
      nixos = inputs.nixpkgs.lib.mapAttrs (
        _: cfg: cfg.config.system.build.toplevel
      ) inputs.self.nixosConfigurations;
    };
  };
}

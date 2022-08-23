{
  description = "A very basic flake";

  outputs = { self, nixpkgs }:
    let pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    {

      packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.tree;

      defaultPackage.x86_64-linux = self.packages.x86_64-linux.tree;

      hydraJobs."tester2" = self.defaultPackage;
      hydraJobs."tester" = self.defaultPackage;
      hydraJobs."tester-readme" = pkgs.runCommand "readme" { } ''
        echo hello worl
        mkdir -p $out/nix-support
        echo "# A readme" > $out/readme.md
        echo "doc readme $out/readme.md" >> $out/nix-support/hydra-build-products
      '';
      hydraJobs.runCommandHook = {
        recurseForDerivations = true;
        example = with nixpkgs.legacyPackages.x86_64-linux; pkgs.writeScript "run-me" ''
          #!${pkgs.runtimeShell}

          ${pkgs.jq}/bin/jq . "$HYDRA_JSON"
        '';
      };
    };
}

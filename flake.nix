{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-24.11";
  };

  outputs = { self, nixpkgs }:
    let pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    {

      packages.x86_64-linux.tree = nixpkgs.legacyPackages.x86_64-linux.tree;

      defaultPackage.x86_64-linux = self.packages.x86_64-linux.tree;

      hydraJobs."tester2" = self.defaultPackage;
      hydraJobs."tester" = self.defaultPackage;
      hydraJobs."tester-readme" = pkgs.runCommand "readme" { } ''
        echo hello worl
        mkdir -p $out/nix-support
        echo "# A readme" > $out/readme.md
        echo "doc readme $out/readme.md" >> $out/nix-support/hydra-build-products
      '';
    };
}

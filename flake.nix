{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-24.11";
  };

  outputs = { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      now = "241211 1213";
    in
    {

      packages.x86_64-linux.tree = nixpkgs.legacyPackages.x86_64-linux.tree;

      packages.x86_64-linux.test = pkgs.runCommand "readme" { } ''
        echo hello world! ${now}
        mkdir -p $out/nix-support
        echo "# A new readme !" > $out/readme.md
        echo "doc readme $out/readme.md" >> $out/nix-support/hydra-build-products
      '';

      defaultPackage.x86_64-linux = self.packages.x86_64-linux.tree;

      hydraJobs.tester5."tester6" = self.defaultPackage;
      hydraJobs.tester3.tester4 = self.defaultPackage;
      hydraJobs."tester2" = self.defaultPackage;
      hydraJobs."tester" = self.defaultPackage;
      hydraJobs."tester-readme" = pkgs.runCommand "readme" { } ''
        echo hello world! ${now}
        mkdir -p $out/nix-support
        echo "# A new readme !! ${now}" > $out/readme.md
        echo "doc readme $out/readme.md" >> $out/nix-support/hydra-build-products
      '';
    };
}

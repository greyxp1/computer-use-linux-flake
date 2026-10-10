{
  description = "Release-tracked Linux computer-use MCP server";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    version = "0.7.15";
    computerUse = pkgs.callPackage ./package.nix {
      inherit version;
      src = pkgs.fetchurl {
        url = "https://github.com/agent-sh/computer-use-linux/releases/download/v${version}/computer-use-linux-x86_64-unknown-linux-gnu";
        hash = "sha256-7NBcwxAnoS3h5rTLI61XYEIO8o+co7ewOU+ksm7Zqdk=";
      };
    };
  in {
    packages.${system} = {
      default = computerUse;
      computer-use-linux = computerUse;
    };
    apps.${system}.default = {
      type = "app";
      program = "${computerUse}/bin/computer-use-linux";
    };
  };
}

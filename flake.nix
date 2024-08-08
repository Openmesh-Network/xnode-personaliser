{
  description = "A well-defined environemnt script importer and execution engine for XnodeOS/Xnode integration environments";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
  };

  outputs = { self, nixpkgs, flake-utils, flake-compat }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        pkg-name = "xnode-personaliser";
        pkg-buildInputs = with pkgs; [ jq curl ];
        pkg-script = (pkgs.writeScriptBin pkg-name (builtins.readFile ./src/xnode-personaliser.sh)).overrideAttrs(old: {
          buildCommand = "${old.buildCommand}\n patchShebangs ''$out";
        });
      in rec {
        defaultPackage = packages.xnode-personaliser;
        packages.xnode-personaliser = pkgs.symlinkJoin {
          name = pkg-name;
          paths = [ pkg-script ] ++ pkg-buildInputs;
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = "wrapProgram $out/bin/${pkg-name} --prefix PATH : $out/bin";
        };
      }
    );
}

{ stdenv
, pkgs
, lib
# package metadata to be set by package repository
, package-name
, package-version
, package-src
, ...
} :
  let
    name = package-name;
    version = package-version;
    src = package-src;

    inputs = with pkgs; [ jq curl gnugrep ];
    script = ( pkgs.writeScriptBin package-name (
        builtins.readFile "${src}/src/xnode-personaliser.sh"
        )
      ).overrideAttrs(old: {
        buildCommand = "${old.buildCommand}\n patchShebangs $out";
      });
  in
  pkgs.symlinkJoin {
    name = name;
    version = version;

    buildInputs = [ pkgs.makeWrapper ];
    paths = [ script ]  ++ inputs;
    postBuild = "wrapProgram $out/bin/${name} --prefix PATH : $out/bin";

    meta = with lib; {
      homepage = "https://openmesh.network/";
      description = "Installs a simple script that takes a script from any applicable personalisation interface (kernel cmdline base64/etc) and provides a well defined runtime environment.";
      mainProgram = name;
      license = with licenses; [ mit ];
      maintainers = with maintainers; [ j-openmesh ];
    };
  }

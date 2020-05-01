{ pkgs ? import <nixpkgs> }:
let
  pkgs' = import ./nix { inherit pkgs; };
  generated = pkgs'.crate2nix.generatedCargoNix {
    name = "daedalos";
    src = ./.;
  };
  daedalos = pkgs'.callPackage generated { };
in
daedalos.rootCrate.build

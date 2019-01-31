let
  moz_overlay = import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz);
  nixpkgs = import <nixpkgs> { overlays = [ moz_overlay ]; };

  rustNightly = (nixpkgs.rustChannelOf { date = "2019-01-26"; channel = "nightly"; }).rust.override {
    extensions = [
      "rust-src"
      "rls-preview"
      "clippy-preview"
      "rustfmt-preview"
    ];
  };

in
  with nixpkgs;
  stdenv.mkDerivation {
    name = "daedalos";
    buildInputs = [
      rustNightly
    ];
  }


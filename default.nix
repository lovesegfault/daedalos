let
  moz_overlay = import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz);
  nixpkgs = import <nixpkgs> { overlays = [ moz_overlay ]; };

  originalRustNightly = nixpkgs.rustChannelOf { date = "2019-02-27"; channel = "nightly"; };
  newRawRust = originalRustNightly.rust.override {
    extensions = [
      "rust-src"
      "rls-preview"
      "clippy-preview"
      "rustfmt-preview"
    ];
  };
  rustNightly = {
    inherit (originalRustNightly) cargo;
    rustc = newRawRust // { src = originalRustNightly.rust-src; };
  };
  nightlyRustPlatform = nixpkgs.makeRustPlatform rustNightly;

  daedalos = with nixpkgs;
  stdenv.mkDerivation {
    name = "daedalos";
    buildInputs = [
      (nixpkgs.callPackage ./bootimage.nix { rustPlatform = nightlyRustPlatform; })
      (nixpkgs.callPackage ./cargo-xbuild.nix { rustPlatform = nightlyRustPlatform; })
      rustNightly.rustc
      rustNightly.cargo
      (qemu.override { numaSupport = false;
                       pulseSupport = false;
                       sdlSupport = false;
                       gtkSupport = false;
                       vncSupport = false;
                       spiceSupport = false;
                       usbredirSupport = false;
                       xenSupport = false;
                       smbdSupport = false;
                       hostCpuOnly = true;
                     })
    ];
  };
in {
  inherit daedalos nixpkgs rustNightly;
}

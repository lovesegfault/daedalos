{ }:
let
  sources = import ./sources.nix;
  overlays = [
    (import sources.nixpkgs-mozilla)
    (
      self: super: rec {
        rustChannel = self.rustChannelOf { channel = "nightly"; };
        rustFull = (rustChannel.rust.override {
          extensions = [
            "clippy-preview"
            "rustfmt-preview"
            "rust-analysis"
            "rust-std"
            "rust-src"
          ];
        });
        cargo = rustFull;
        rustc = rustFull;
      }
    )
    (self: super: { naersk = self.callPackage sources.naersk {}; })
    (self: super: {
      bootimage = self.naersk.buildPackage {
        name = "bootimage";
        src = sources.bootimage;
      };
    })
  ];
  pkgs = import <nixpkgs> { inherit overlays; };
in
pkgs

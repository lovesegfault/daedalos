{}:
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
    (self: super: { crate2nix = self.callPackage sources.crate2nix {}; })
  ];
  pkgs = import <nixpkgs> { inherit overlays; };
in
pkgs

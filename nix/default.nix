{ pkgs ? import <nixpkgs> }:
let
  sources = import ./sources.nix;
  overlays = [
    (import sources.nixpkgs-mozilla)
    (
      self: super: {
        rustChannel = self.rustChannelOf {
          rustToolchain = ../rust-toolchain;
          sha256 = "11i2had5n9nz2ywaglg6j3vb9b2ncxpk5r83lbkwgvpj9q93afri";
        };
        rustFull = (self.rustChannel.rust.override {
          extensions = [
            "clippy-preview"
            "rls-preview"
            "rust-analysis"
            "rust-src"
            "rust-std"
            "rustfmt-preview"
          ];
        });
        cargo = self.rustFull;
        rustc = self.rustFull;
      }
    )
    (self: super: { crate2nix = self.callPackage (sources.crate2nix + "/tools.nix") { }; })
    (self: super: {
      bootimage =
        let
          generated = self.crate2nix.generatedCargoNix {
            name = "bootimage";
            src = sources.bootimage;
          };
          bootimage = self.callPackage generated { };
        in
        bootimage.rootCrate.build;
    })
  ];
in
pkgs { inherit overlays; }

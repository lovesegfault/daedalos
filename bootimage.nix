{ stdenv, fetchFromGitHub, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  name = "bootimage-${version}";
  version = "0.6.5";

  cargoSha256 = "0syi2i3xbww23p2hd4r29mlkm1plnv06g8jnb4xg7hmpwq2qgfks";

  src = fetchFromGitHub {
    owner = "rust-osdev";
    repo = "bootimage";
    rev = "v${version}";
    sha256 = "1bd0a8p53fr8yrzalsikfvglkjrphini02mia1xy6z5hr77gm8p3";
  };

  doCheck = false;

  preConfigure = ''
    export HOME=`mktemp -d`
  '';
}


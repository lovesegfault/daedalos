{ stdenv, fetchFromGitHub, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  name = "bootimage-${version}";
  version = "0.6.5";

  cargoSha256 = "08zzn3a32xfjkmpawcjppn1mr26ws3iv40cckiz8ldz4qc8y9gdh";

  src = fetchFromGitHub {
    owner = "rust-osdev";
    repo = "bootimage";
    rev = "v${version}";
    sha256 = "08zzn3a32xfjkmpawcjppn1mr26ws3iv40cckiz8ldz4qc8y9gdh";
  };

  # Some tests fail, but Travis ensures a proper build
  doCheck = true;
}


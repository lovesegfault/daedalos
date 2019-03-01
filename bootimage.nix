{ stdenv, fetchFromGitHub, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  name = "bootimage-${version}";
  version = "0.6.5";

  cargoSha256 = "1za65pj5yi631sfdiz5aibaxpqj9zswf15q8szsmg5w0qpnzxbcd";

  src = fetchFromGitHub {
    owner = "rust-osdev";
    repo = "bootimage";
    rev = "v${version}";
    sha256 = "1bd0a8p53fr8yrzalsikfvglkjrphini02mia1xy6z5hr77gm8p3";
  };

  doCheck = false;
}


let
  pkgs = import ./nix {};
in
pkgs.mkShell {
  name = "daedalos";
  nativeBuildInputs = with pkgs; [
    cargo
    llvmPackages_latest.clang
    llvmPackages_latest.lld

    cargo-edit
    cargo-tree
    qemu_kvm
    rust-analyzer

    niv
    nixpkgs-fmt
  ];
}

all: check build test
iso: check build test release bootloader

TARGET="x86_64-daedalos.json"

check:
	cargo check
fmt:
	cargo fmt

lint:
	cargo clippy

test:
	cargo test

clean:
	cargo clean

build:
	cargo xbuild --target=${TARGET}

release:
	cargo xbuild --release --target=${TARGET}

bootloader:
	bootimage build

run: check build
	qemu-system-x86_64 -curses -drive format=raw,file=./target/x86_64-daedalos/debug/bootimage-daedalos.bin

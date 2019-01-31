all: check build test
iso: check build test release bootloader

TARGET="x86_64-daedalos.json"

check:
	cargo check

fmt:
	cargo fmt

lint:
	cargo clippy

test: build
	cargo test
	bootimage test

clean:
	cargo clean

build: check
	cargo xbuild --target=${TARGET}

release:
	cargo xbuild --release --target=${TARGET}

bootloader: build
	bootimage build

run: bootloader
	qemu-system-x86_64 \
    -drive format=raw,file=target/x86_64-daedalos/debug/bootimage-daedalos.bin \
    -serial mon:stdio \
    -device isa-debug-exit,iobase=0xf4,iosize=0x04 \
    -display none\
	|| true

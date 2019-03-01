all: release
iso: bootloader

TARGET="x86_64-daedalos.json"

fmt:
	cargo fmt

clean:
	cargo clean

check:
	cargo check

lint: check
	cargo clippy

test: lint
	cargo test
	bootimage test

build: test
	cargo xbuild --target=${TARGET}

release: test
	cargo xbuild --release --target=${TARGET}

bootloader: release
	bootimage build

run: bootloader
	qemu-system-x86_64 \
    -drive format=raw,file=target/x86_64-daedalos/release/bootimage-daedalos.bin \
    -serial mon:stdio \
    -device isa-debug-exit,iobase=0xf4,iosize=0x04 \
    -display none\
	|| true

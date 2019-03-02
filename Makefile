all: release
iso: bootloader

TARGET="x86_64-daedalos.json"
MODE="debug"

fmt:
	cargo fmt

clean:
	cargo clean

check:
	cargo check

lint: check
	cargo xclippy --target=${TARGET}

test: lint
	cargo test
	bootimage test

build:
	cargo xbuild --target=${TARGET}

bootloader: build
	bootimage build

run: bootloader
	qemu-system-x86_64 \
    -drive format=raw,file=target/x86_64-daedalos/debug/bootimage-daedalos.bin \
    -serial mon:stdio \
    -device isa-debug-exit,iobase=0xf4,iosize=0x04 \
	-display gtk \
	|| true

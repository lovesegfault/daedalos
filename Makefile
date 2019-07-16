all: lint build

MODE="debug"

fmt:
	cargo fmt

clean:
	cargo clean

check:
	cargo xcheck

lint: check
	cargo xclippy

test: lint
	cargo xtest
	bootimage test

build:
	cargo xbuild

bootloader: build
	bootimage build

run:
	cargo xrun

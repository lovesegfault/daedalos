all: check build test

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

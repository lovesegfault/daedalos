all: check build test

check:
	cargo check

fmt:
	cargo fmt

lint:
	cargo clippy

test:
	cargo test

build:
	cargo rustc -- -Z pre-link-arg=-nostartfiles

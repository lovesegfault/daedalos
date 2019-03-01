#![cfg_attr(not(test), no_std)]
#![feature(abi_x86_interrupt)]

pub mod interrupts;
pub mod serial;
pub mod vga;

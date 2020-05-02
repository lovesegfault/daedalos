#![feature(abi_x86_interrupt)]
#![no_main]
#![no_std]

use daedalos::{exit_qemu, serial_println, QemuExitCode};
use lazy_static::lazy_static;
use x86_64::structures::idt::{InterruptDescriptorTable, InterruptStackFrame};

extern "x86-interrupt" fn test_double_fault_handler(
    _stack_frame: &mut InterruptStackFrame,
    _error_code: u64,
) -> ! {
    serial_println!("[ok]");
    exit_qemu(QemuExitCode::Success);
    daedalos::hlt_loop();
}

lazy_static! {
    static ref TEST_IDT: InterruptDescriptorTable = {
        let mut idt = InterruptDescriptorTable::new();
        unsafe {
            idt.double_fault
                .set_handler_fn(test_double_fault_handler)
                .set_stack_index(daedalos::gdt::DOUBLE_FAULT_IST_INDEX);
        }

        idt
    };
}

pub fn init_test_idt() { TEST_IDT.load(); }

#[panic_handler]
fn panic(info: &core::panic::PanicInfo) -> ! { daedalos::test_panic_handler(info) }

#[no_mangle]
pub extern fn _start() -> ! {
    daedalos::serial_print!("stack_overflow... ");

    daedalos::gdt::init();
    init_test_idt();

    // trigger a stack overflow
    stack_overflow();

    panic!("Execution continued after stack overflow");
}

#[allow(unconditional_recursion)]
fn stack_overflow() { stack_overflow(); }

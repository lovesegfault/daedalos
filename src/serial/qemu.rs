use x86_64::instructions::port::Port;

pub unsafe fn exit_qemu() {
    let mut port = Port::<u32>::new(0xf4);
    port.write(0);
}

NAME = DaedalOS
ARCH = x86_64
SHELL := /bin/bash
PATH := $(PATH):$(shell pwd)/xcompiler/$(ARCH)-elf/bin/

KER_SRC   = ./kernel
ARCH_SRC  = $(KER_SRC)/arch/$(ARCH)
ASM_SRC   = $(wildcard $(ARCH_SRC)/*.asm)
C_SRC     = $(wildcard $(ARCH_SRC)/*.c)

BUILD_DIR = ./build/$(ARCH)

ASM_OBJ   = $(patsubst $(ARCH_SRC)/%.asm, $(BUILD_DIR)/%.o, $(ASM_SRC))
C_OBJ     = $(patsubst $(ARCH_SRC)/%.c, $(BUILD_DIR)/%.o, $(C_SRC))
KERNEL    = $(BUILD_DIR)/$(NAME)-$(ARCH).bin
GRUB_CFG  = $(KER_SRC)/grub.cfg
ISO       = $(BUILD_DIR)/$(NAME)-$(ARCH).iso

V        ?= @

ifeq ($(ARCH), x86_64)
QEMU          = qemu-system-x86_64
TARGET        = x86_64
AS            = nasm
ASFLAGS       = -felf64
CC            = x86_64-elf-gcc
CFLAGS        = -std=c11 -ffreestanding -mno-red-zone -O2 -Wall -Wextra \
				-Wpedantic
LDFLAGS       = -nostdlib -z max-page-size=0x1000 -lgcc
GRUB_MKRESCUE = grub-mkrescue
VB            = virtualbox
VBM           = VBoxManage
endif

$(shell mkdir -p $(BUILD_DIR))

.PHONY: all xcompiler iso run clean

all: xcompiler $(KERNEL)

$(KERNEL): $(ARCH_SRC)/linker.ld $(C_OBJ) $(ASM_OBJ)
#	$(V)$(CC) $(LDFLAGS) -T $(KER_SRC)/linker.ld $(C_OBJ) $(ASM_OBJ) -o $@

$(BUILD_DIR)/%.o: $(ARCH_SRC)/%.asm
	$(V)$(AS) $(ASFLAGS) -o $@ $^

$(BUILD_DIR)/%.o: $(ARCH_SRC)/%.c
	$(V)$(CC) -c $(CFLAGS) -o $@ $^

xcompiler:
	$(V)bash scripts/xcompiler.sh &> /dev/null
	@echo $(SYSROOT)

iso: $(ISO)
$(ISO): $(KERNEL) $(GRUB_CFG)
	$(V)mkdir -p $(BUILD_DIR)/iso/boot/grub
	$(V)cp $(GRUB_CFG) $(BUILD_DIR)/iso/boot/grub
	$(V)cp $(KERNEL) $(BUILD_DIR)/iso/boot/kernel.bin
	$(V)$(GRUB_MKRESCUE) -o $(ISO) $(BUILD_DIR)/iso
	$(V)rm -rf $(BUILD_DIR)/iso

run: $(ISO)
	$(V)$(QEMU) -cdrom $<
run-vb: $(ISO)
	$(V)$(VBM)  unregistervm $(NAME) --delete || true
	$(V)$(VBM)  createvm --name $(NAME) --register
	$(V)$(VBM)  modifyvm $(NAME) --memory 2048
	$(V)$(VBM)  modifyvm $(NAME) --vram 128
	$(V)$(VBM)  modifyvm $(NAME) --nic1 nat
	$(V)$(VBM)  modifyvm $(NAME) --nictype1 82540EM
	$(V)$(VBM)  modifyvm $(NAME) --nictrace1 on
	$(V)$(VBM)  modifyvm $(NAME) --nictracefile1 $(BUILD_DIR)/network.pcap
	$(V)$(VBM)  modifyvm $(NAME) --uart1 0x3F8 4
	$(V)$(VBM)  modifyvm $(NAME) --uartmode1 file $(BUILD_DIR)/vb-serial.log
	$(V)$(VBM)  storagectl $(NAME) --name "IDE Controller" --add ide
	$(V)$(VBM)  storageattach $(NAME) --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium $(ISO)
	$(V)$(VB) --startvm $(NAME) --dbg

clean:
	$(V)rm -rf ./build

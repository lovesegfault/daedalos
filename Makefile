NAME := DaedalOS
ARCH := x86_64

SRC_DIR := ./src/arch/$(ARCH)
BUILD_DIR := ./build/arch/$(ARCH)

KERNEL := $(BUILD_DIR)/$(NAME)-$(ARCH).bin
ISO := $(BUILD_DIR)/$(NAME)-$(ARCH).iso

CFLAGS := -std=c11 -ffreestanding -O2 -Wall -Werror
GRUB_CFG := $(SRC_DIR)/grub.cfg

OBJ :=
V ?= @

ifeq ($(ARCH), x86_64)
QEMU := qemu-system-x86_64
TARGET := x86_64
AS := nasm
ASFLAGS := -felf64
CC := gcc
GRUB_MKRESCUE := grub-mkrescue
VB := virtualbox
endif

.PHONY: all clean run iso

all: $(KERNEL)

$(KERNEL): src/arch/$(ARCH)/linker.ld $(OBJ)
	$(V)ld -n -T $(SRC_DIR)/linker.ld $(OBJ) -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	$(V)$(CC) -c $(CFLAGS) -o $@ $^

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.asm
	$(V)$(AS) $(ASFLAGS) -o $@ $^

clean:
	$(V)rm -rf ./build

iso: $(ISO)
$(ISO): $(KERNEL) $(GRUB_CFG)
	$(V)mkdir -p $(BUILD_DIR)/iso/boot/grub
	$(V)cp $(GRUB_CFG) $(BUILD_DIR)/iso/boot/grub
	$(V)cp $(KERNEL) $(BUILD_DIR)/iso/boot/kernel.bin
	$(V)$(GRUB_MKRESCUE) -o $(ISO) $(BUILD_DIR)/iso
	$(V)rm -rf $(BUILD_DIR)/iso

run: $(ISO)
	$(V)$(QEMU) -cdrom $@

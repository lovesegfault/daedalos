NAME := DaedalOS
ARCH := x86_64

SRC_DIR := ./src/arch/$(ARCH)
BUILD_DIR := ./build/arch/$(ARCH)

KERNEL := $(BUILD_DIR)/$(NAME)-$(ARCH).bin
ISO := $(BUILD_DIR)/$(NAME)-$(ARCH).iso

CFLAGS := -std=c11 -ffreestanding -O2 -Wall -Werror
GRUB_CFG := $(SRC_DIR)/grub.cfg

ASM_SRC := $(wildcard $(SRC_DIR)/*.asm)
ASM_OBJ := $(patsubst $(SRC_DIR)/%.asm, $(BUILD_DIR)/%.o, $(ASM_SRC))
C_SRC := $(wildcard $(SRC_DIR)/*.c)
C_OBJ := $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(C_SRC))
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

$(shell mkdir -p $(BUILD_DIR))

.PHONY: all clean run iso

all: $(KERNEL)


$(KERNEL): $(SRC_DIR)/linker.ld $(C_OBJ) $(ASM_OBJ)
	$(V)ld -n -T $^ -o $@

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
	$(V)$(QEMU) -cdrom $<

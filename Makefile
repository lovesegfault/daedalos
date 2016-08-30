NAME = DaedalOS
ARCH = x86_64

SRC_DIR   = ./kernel/$(ARCH)
BUILD_DIR = ./build/$(ARCH)
KERNEL    = $(BUILD_DIR)/$(NAME)-$(ARCH).bin
ISO       = $(BUILD_DIR)/$(NAME)-$(ARCH).iso
GRUB_CFG  = $(SRC_DIR)/grub.cfg
ASM_SRC   = $(wildcard $(SRC_DIR)/*.asm)
ASM_OBJ   = $(patsubst $(SRC_DIR)/%.asm, $(BUILD_DIR)/%.o, $(ASM_SRC))
C_SRC     = $(wildcard $(SRC_DIR)/*.c)
C_OBJ     = $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(C_SRC))
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

.PHONY: all clean run iso

all: $(KERNEL)


$(KERNEL): $(SRC_DIR)/linker.ld $(C_OBJ) $(ASM_OBJ)
	$(V)$(CC) $(LDFLAGS) -T $(SRC_DIR)/linker.ld $(C_OBJ) $(ASM_OBJ) -o $@

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

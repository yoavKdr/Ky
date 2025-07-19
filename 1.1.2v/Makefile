# ==== Configuration ====

# Directories
SRC_DIR := src
BUILD_DIR := build

# Sub directories
BOOT_DIR := boot
KERNEL_DIR := kernel

# Tools
ASM := nasm
QEMU := /mnt/c/Program\ Files/qemu/qemu-system-x86_64.exe
CC := clang
LD := ld.lld

# Flags
ASM_FLAGS := -f elf64
CC_FLAGS := -Iinc -ggdb -c -ffreestanding -target x86_64-none-elf
LD_FLAGS = -Ttext 0x8200
LD_FLAGS_BIN = ${LD_FLAGS} --oformat binary

# Files
BOOTLOADER_SRC := $(SRC_DIR)/$(BOOT_DIR)/bootloader.asm
BOOTLOADER_BIN := $(BUILD_DIR)/$(BOOT_DIR)/bootloader.bin

KERNEL_SRC := $(SRC_DIR)/$(KERNEL_DIR)/kernel.c
KERNEL_ELF := $(BUILD_DIR)/$(KERNEL_DIR)/kernel.elf
KERNEL_BIN := $(BUILD_DIR)/$(KERNEL_DIR)/kernel.bin

KERNEL_ENTRY_SRC := $(SRC_DIR)/$(KERNEL_DIR)/kernel_entry.asm

# Result
OS_IMAGE := $(BUILD_DIR)/ky-x86_64.img


# ==== Targets ====
# Compile the bootloader
$(BOOTLOADER_BIN): $(BOOTLOADER_SRC) | $(BUILD_DIR)/$(BOOT_DIR)
	$(ASM) -I $(SRC_DIR)/$(BOOT_DIR)/ $< -o $@

# Compile the kernel
$(KERNEL_BIN): ${KERNEL_SRC} | $(BUILD_DIR)/$(KERNEL_DIR)
	$(CC) $(CC_FLAGS) -o $@ -c $<
$(KERNEL_ELF): ${OBJ} | $(BUILD_DIR)/$(KERNEL_DIR)
	${LD} -o $@ ${LD_FLAGS} $^
patch: $(KERNEL_BIN)
	@kernel_size=$$(wc -c < $<); \
	kernel_sectors=$$(( ($$kernel_size + 511) / 512 )); \
	printf %02x $$kernel_sectors | xxd -r -p | dd of=$(BOOTLOADER_BIN) bs=1 seek=2 count=1 conv=notrunc

# Compile the image
$(OS_IMAGE): $(BOOTLOADER_BIN) $(KERNEL_BIN) | $(BUILD_DIR)
	cp $(BOOTLOADER_BIN) $(OS_IMAGE)
	cat $(KERNEL_BIN) >> $(OS_IMAGE)
	dd if=/dev/zero bs=1 count=512 >> $(OS_IMAGE)
# ==== Commends ====
clean:
	rm -rf $(BUILD_DIR)

mdir:
	mkdir -p $(BUILD_DIR)
	mkdir -p $(BUILD_DIR)/$(BOOT_DIR)
	mkdir -p $(BUILD_DIR)/$(KERNEL_DIR)
build: mdir $(KERNEL_ELF) patch $(OS_IMAGE)

run:
	$(QEMU) -drive format=raw,file=$(OS_IMAGE)

cbr: clean mdir build run

size:
	wc -c <$(KERNEL_SRC)

entry:
	nm $(OS_IMAGE) | grep _start
	nm $(OS_IMAGE) | grep main
	readelf -h $(OS_IMAGE) | grep Entry

# ==== Meta ====
.PHONY: clean mdir build run cbr size entry
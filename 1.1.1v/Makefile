# ==== Configuration ====

# Directories
SRC_DIR := src
BUILD_DIR := build

# Sub directories
BOOT_DIR := boot
KERNEL_DIR := kernel

# Tools
NASM := nasm
QEMU := /mnt/c/Program\ Files/qemu/qemu-system-x86_64.exe
GCC := gcc
LD := ld
GDB = gdb 
OBJCOPY := objcopy

# Flags
NASM_FLAGS := -f bin
GCC_FLAGS := -ffreestanding -mno-red-zone -m64 -O2 -nostdlib
LD_FLAGS := -n

# Files
BOOTLOADER_SRC := $(SRC_DIR)/$(BOOT_DIR)/bootloader.asm
BOOTLOADER_BIN := $(BUILD_DIR)/$(BOOT_DIR)/bootloader.bin

BOOTLOADER_EXTEND_SRC := $(SRC_DIR)/$(BOOT_DIR)/bootloader_extend.asm
BOOTLOADER_EXTEND_BIN := $(BUILD_DIR)/$(BOOT_DIR)/bootloader_extend.bin

KERNEL_SRC := $(SRC_DIR)/$(KERNEL_DIR)/kernel.c
KERNEL_OBJ := $(BUILD_DIR)/$(KERNEL_DIR)/kernel.o
KERNEL_ELF := $(BUILD_DIR)/$(KERNEL_DIR)/kernel.elf
KERNEL_BIN := $(BUILD_DIR)/$(KERNEL_DIR)/kernel.bin

KERNEL_ENTRY_SRC := $(SRC_DIR)/$(KERNEL_DIR)/kernel_entry.asm
KERNEL_ENTRY_OBJ := $(BUILD_DIR)/$(KERNEL_DIR)/kernel_entry.o

LINKER_SCRIPT := $(SRC_DIR)/$(KERNEL_DIR)/linker.ld

# Result
OS_IMAGE := $(BUILD_DIR)/ky-x86_64.img


# ==== Targets ====
# Compile the bootloader
$(BOOTLOADER_BIN): $(BOOTLOADER_SRC) | $(BUILD_DIR)/$(BOOT_DIR)
	$(NASM) $(NASM_FLAGS) -I $(SRC_DIR)/$(BOOT_DIR)/ $< -o $@

# Compile the extended bootloader
$(BOOTLOADER_EXTEND_BIN): $(BOOTLOADER_EXTEND_SRC) | $(BUILD_DIR)/$(BOOT_DIR)
	$(NASM) $(NASM_FLAGS) -I $(SRC_DIR)/$(BOOT_DIR)/ $< -o $@

# Compile the kernel entry
$(KERNEL_ENTRY_OBJ): $(KERNEL_ENTRY_SRC) | $(BUILD_DIR)/$(KERNEL_DIR)
	$(NASM) -f elf64 $< -o $@

# Compile the kernel
$(KERNEL_OBJ): $(KERNEL_SRC) | $(BUILD_DIR)/$(KERNEL_DIR)
	$(GCC) $(GCC_FLAGS) -c $< -o $@
$(KERNEL_ELF): $(KERNEL_ENTRY_OBJ) $(KERNEL_OBJ) $(LINKER_SCRIPT) | $(BUILD_DIR)/$(KERNEL_DIR)
	$(LD) $(LD_FLAGS) -T $(LINKER_SCRIPT) -o $@ $(KERNEL_ENTRY_OBJ) $(KERNEL_OBJ)
$(KERNEL_BIN): $(KERNEL_ELF) | $(BUILD_DIR)/$(KERNEL_DIR)
	$(OBJCOPY) -O binary $< $@

	
# Compile the image
$(OS_IMAGE): $(BOOTLOADER_BIN) $(BOOTLOADER_EXTEND_BIN) $(KERNEL_BIN) | $(BUILD_DIR)
	dd if=/dev/zero of=$@ bs=512 count=5
	dd if=$(BOOTLOADER_BIN) of=$@ bs=512 count=1 conv=notrunc
	dd if=$(BOOTLOADER_EXTEND_BIN) of=$@ bs=512 count=2 seek=1 conv=notrunc
	#dd if=$(KERNEL_BIN) of=$@ bs=512 count=2 conv=notrunc

# ==== Commends ====
clean:
	rm -rf $(BUILD_DIR)

mdir:
	mkdir -p $(BUILD_DIR)
	mkdir -p $(BUILD_DIR)/$(BOOT_DIR)
	mkdir -p $(BUILD_DIR)/$(KERNEL_DIR)


build: $(OS_IMAGE)

run:
	$(QEMU) -drive format=raw,file=$(OS_IMAGE) -serial stdio

cbr: clean mdir build run

size:
	wc -c <$(KERNEL_SRC)
entry:
	nm $(KERNEL_ELF) | grep _start
	nm $(KERNEL_ELF) | grep main
	readelf -h $(KERNEL_ELF) | grep Entry
# ==== Meta ====
.PHONY: clean mdir build run cbr size entry
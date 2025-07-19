# ==== Configuration ====
# Directories
BUILD_DIR := ../build/kernel
$(shell mkdir -p $(BUILD_DIR))

# Tools
CC = clang
GDB = gdb 
LD = ld.lld
ASM = nasm

# Flags
CCFLAGS = -Iinc -ggdb -c -ffreestanding -target x86_64-none-elf
LDFLAGS = -Ttext 0x8200
LDFLAGS_BIN = ${LDFLAGS} --oformat binary
ASFLAGS = -f elf64


# ==== Targets ====
C_SRC = $(shell find . -type f -name "*.c")
ASM_SRC = $(shell find . -type f -name "*.asm")
OBJ := $(patsubst %.asm,$(BUILD_DIR)/%.o,$(ASM_SRC)) $(patsubst %.c,$(BUILD_DIR)/%.o,$(C_SRC))

# Compile The C files into build dir
$(BUILD_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CCFLAGS) -o $@ $<

# Compile The ASM files into build dir
$(BUILD_DIR)/%.o: %.asm
	@mkdir -p $(dir $@)
	$(ASM) $< $(ASFLAGS) -o $@

# ==== Commends ====
all: kernel.bin kernel.elf

kernel.bin: $(OBJ)
	$(LD) -o $(BUILD_DIR)/kernel.bin $(LDFLAGS_BIN) $^

kernel.elf: $(OBJ)
	$(LD) -o $(BUILD_DIR)/kernel.elf $(LDFLAGS) $^

clean:
	rm -rf $(BUILD_DIR)
# ==== Configuration ====
# Directories
BUILD_DIR := ../build/kernel
$(shell mkdir -p $(BUILD_DIR))

# Tools
ASM = nasm
CC = clang
CCPP = clang++
LD = ld.lld

# Flags
ASFLAGS = -f elf64
CCFLAGS = -Iinc -ggdb -c -ffreestanding -target x86_64-none-elf
CCPPFLAGS = -Iinc -ggdb -c -ffreestanding -target x86_64-none-elf -std=c++20

LDFLAGS = -Ttext 0x8200
LDFLAGS_BIN = ${LDFLAGS} --oformat binary


# ==== Targets ====
ASM_SRC = $(shell find . -type f -name "*.asm")
C_SRC = $(shell find . -type f -name "*.c")
CPP_SRC = $(shell find . -type f -name "*.cpp")
OBJ := \
  $(patsubst %.asm,$(BUILD_DIR)/%.o,$(ASM_SRC)) \
  $(patsubst %.c,$(BUILD_DIR)/%.o,$(C_SRC)) \
  $(patsubst %.cpp,$(BUILD_DIR)/%.o,$(CPP_SRC))

# Compile The ASM files into build dir
$(BUILD_DIR)/%.o: %.asm
	@mkdir -p $(dir $@)
	$(ASM) $< $(ASFLAGS) -o $@

# Compile The C files into build dir
$(BUILD_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CCFLAGS) -o $@ $<

# Compile The C++ files into build dir
$(BUILD_DIR)/%.o: %.cpp
	@mkdir -p $(dir $@)
	$(CCPP) $(CCPPFLAGS) -o $@ $<


# ==== Commends ====
all: kernel.bin kernel.elf

kernel.bin: $(OBJ)
	$(LD) -o $(BUILD_DIR)/kernel.bin $(LDFLAGS_BIN) $^

kernel.elf: $(OBJ)
	$(LD) -o $(BUILD_DIR)/kernel.elf $(LDFLAGS) $^

clean:
	rm -rf $(BUILD_DIR)
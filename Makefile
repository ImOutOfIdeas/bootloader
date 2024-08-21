AS = nasm
ASFLAGS = -f bin

# Define source and build directories
SRC_DIR = src
BUILD_DIR = build

# Recursively locate all .asm files in the source directory
# ASM_SRCS = $(shell find $(SRC_DIR) -name '*.asm')
ASM_SRCS = src/boot.asm

# Convert .asm file paths to .bin file paths in the build directory
BIN_FILES = $(patsubst $(SRC_DIR)/%.asm, $(BUILD_DIR)/%.bin, $(ASM_SRCS))

# Default target to build all .bin files in the build directory
all: $(BIN_FILES)
	qemu-system-x86_64 build/boot.bin --display curses

# Rule to create build directory if it does not exist
$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

# Assemble each .asm file into a .bin file
$(BUILD_DIR)/%.bin: $(SRC_DIR)/%.asm | $(BUILD_DIR)
	@echo "Assembling $<..."
	$(AS) $(ASFLAGS) -o $@ $<

# Clean up generated files
clean:
	@echo "Cleaning up..."
	rm -f $(BIN_FILES)

.PHONY: all clean

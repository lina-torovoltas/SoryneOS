DISK_IMG := disk.img

SRC_DIR := src
BUILD_DIR := build
BOOTLOADER_SRC := $(SRC_DIR)/bootloader.asm
KERNEL_SRC := $(SRC_DIR)/kernel.asm
BOOTLOADER_BIN := $(BUILD_DIR)/bootloader.bin
KERNEL_BIN := $(BUILD_DIR)/kernel.bin
DISK_PATH := $(BUILD_DIR)/image/$(DISK_IMG)

.PHONY: all bootloader kernel image clean

all: bootloader kernel image

$(BOOTLOADER_BIN): $(BOOTLOADER_SRC)
	@mkdir -p $(BUILD_DIR)
	@echo "Building bootloader..."
	@fasm $< $@

$(KERNEL_BIN): $(KERNEL_SRC)
	@mkdir -p $(BUILD_DIR)
	@echo "Building kernel..."
	@fasm $< $@

$(DISK_PATH): $(BOOTLOADER_BIN) $(KERNEL_BIN)
	@mkdir -p $(BUILD_DIR)/image
	@echo "Creating disk image..."
	@cat $(BOOTLOADER_BIN) $(KERNEL_BIN) > $@

image: $(DISK_PATH)
	@echo "Disk image is ready: $@"

bootloader: $(BOOTLOADER_BIN)
	@echo "Bootloader built!"

kernel: $(KERNEL_BIN)
	@echo "Kernel built!"

clean:
	@echo "Cleaning up..."
	@rm -rf $(BUILD_DIR)
	@echo "Clean complete!"

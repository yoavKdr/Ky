#!/bin/bash

set -e

# ==== Cleaning ====
echo "🧹 Cleaning build..."
rm -rf build
mkdir -p build

# ==== Assembling ====
echo "🛠 Assembling bootloader..."
mkdir -p build/boot
(cd boot && nasm -o ../build/boot/bootloader.bin bootloader.asm -l ../build/boot/bootloader.lst)

echo "🧠 Compiling kernel..."
(make -C kernel)

# ==== Kernel Size Patch ====
echo "📏 Calculating kernel size..."
kernel_size_bytes=$(wc -c < build/kernel/kernel.bin)
kernel_sectors=$(( (kernel_size_bytes + 511) / 512 ))

echo "🔢 Kernel size: $kernel_size_bytes bytes"
echo "📦 Kernel sectors (rounded up): $kernel_sectors"

# --- Sanity check ---
if [[ -z "$kernel_sectors" || "$kernel_sectors" -lt 1 || "$kernel_sectors" -gt 255 ]]; then
    echo "❌ Invalid kernel sector count: $kernel_sectors"
    exit 1
fi

# --- Patch sector count at offset 0xDE (222) ---
kernel_sector_offset=222
echo "🧩 Patching sector count into bootloader at offset $kernel_sector_offset (0xDE)..."
printf "%02x" "$kernel_sectors" | xxd -r -p | dd of=build/boot/bootloader.bin bs=1 seek=$kernel_sector_offset count=1 conv=notrunc status=none

# ==== Creating Image ====
echo "💾 Creating os Image..."
cp build/boot/bootloader.bin build/Ky_x64.img
truncate -s 1536 build/Ky_x64.img  # ensure bootloader is 3 sectors
cat build/kernel/kernel.bin >> build/Ky_x64.img

echo "✅ Build finished successfully!"

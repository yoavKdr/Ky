#!/bin/bash

set -e

echo "🧹 Cleaning build..."
rm -f os.img
(make -C kernel clean)

echo "🛠 Assembling bootloader..."
(cd Boot && nasm -o bootloader bootloader.asm -l bootloader.lst)

echo "🧠 Compiling kernel..."
(make -C kernel)

# --- Calculate kernel size in sectors ---
echo "📏 Calculating kernel size..."
kernel_size_bytes=$(wc -c < kernel/kernel)
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
printf "%02x" "$kernel_sectors" | xxd -r -p | dd of=Boot/bootloader bs=1 seek=$kernel_sector_offset count=1 conv=notrunc status=none

# --- Create final OS image ---
echo "💾 Creating os.img..."
cp Boot/bootloader ./os.img
truncate -s 1536 os.img  # ensure bootloader is 3 sectors
cat kernel/kernel >> os.img

echo "✅ Build finished successfully!"

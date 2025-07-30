# Makefile for Elementra_OS

# Tools
AS = nasm
CC = i686-elf-gcc
LD = i686-elf-ld

# Flags
ASFLAGS = -f elf
CFLAGS = -ffreestanding -O2 -Wall -Wextra
LDFLAGS = -T linker.ld

# Files
SRC = kernel/kernel.c
OBJ = build/boot.o build/kernel.o
ISO = build/elementra.iso

all: $(ISO)

build/boot.o: boot/boot.asm
	$(AS) $(ASFLAGS) $< -o $@

build/kernel.o: $(SRC)
	$(CC) $(CFLAGS) -c $< -o $@

$(ISO): $(OBJ) linker.ld
	$(LD) $(LDFLAGS) $(OBJ) -o build/elementra.bin
	mkdir -p build/isofiles/boot
	cp build/elementra.bin build/isofiles/boot/elementra.bin
	grub-mkrescue -o $(ISO) build/isofiles

clean:
	rm -rf build/*.o build/*.bin build/*.iso build/isofiles

AS = nasm
CC = gcc
LD = ld

CFLAGS = -m32 -ffreestanding -nostdlib -Wall -Wextra
ASFLAGS = -f elf32
LDFLAGS = -m elf_i386 -T linker.ld -nostdlib

KERNEL = myos.kernel

OBJS = boot.o kernel.o vga.o pic.o keyboard.o

all: $(KERNEL)

$(KERNEL): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $^

%.o: %.asm
	$(AS) $(ASFLAGS) $< -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

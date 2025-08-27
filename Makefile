# Makefile with automatic file discovery
AS = nasm
CC = gcc
LD = ld
GRUB_MKRESCUE = grub-mkrescue

CFLAGS = -m32 -ffreestanding -nostdlib -Wall -Wextra -I./include
ASFLAGS = -f elf32
LDFLAGS = -m elf_i386 -T boot/linker.ld -nostdlib

KERNEL = globus25.kernel
ISO = globus25.iso

# Automatic source discovery
BOOT_ASM_SRCS = $(wildcard boot/*.asm)
BOOT_OBJS = $(BOOT_ASM_SRCS:.asm=.o)

ALL_ASM_SRCS = $(shell find include -name '*.asm')
ALL_ASM_OBJS = $(ALL_ASM_SRCS:.asm=.o)

KERNEL_C_SRCS = $(wildcard kernel/*.c)
KERNEL_ASM_SRCS = $(wildcard kernel/*.asm)
KERNEL_OBJS = $(KERNEL_C_SRCS:.c=.o) $(KERNEL_ASM_SRCS:.asm=.o)

# Find ALL .c files in include/ and its subdirectories
DRIVER_C_SRCS = $(shell find include -name '*.c')
DRIVER_OBJS = $(DRIVER_C_SRCS:.c=.o)

# Combine all object files
ALL_OBJS = $(BOOT_OBJS) $(KERNEL_OBJS) $(DRIVER_OBJS) $(ALL_ASM_OBJS)

all: $(ISO)

$(ISO): $(KERNEL)
	@mkdir -p isodir/boot/grub
	cp $(KERNEL) isodir/boot/
	cp grub.cfg isodir/boot/grub/
	$(GRUB_MKRESCUE) -o $(ISO) isodir

$(KERNEL): $(ALL_OBJS)
	$(LD) $(LDFLAGS) -o $@ $^

# Generic compilation rules
%.o: %.asm
	$(AS) $(ASFLAGS) $< -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(ALL_OBJS) $(KERNEL) $(ISO)
	rm -rf isodir

run: $(ISO)
	qemu-system-x86_64 -cdrom $(ISO) -m 256M

# Debug info
debug:
	@echo "Boot sources: $(BOOT_ASM_SRCS)"
	@echo "Boot objects: $(BOOT_OBJS)"
	@echo "Kernel C sources: $(KERNEL_C_SRCS)"
	@echo "Kernel ASM sources: $(KERNEL_ASM_SRCS)"
	@echo "Driver C sources: $(DRIVER_C_SRCS)"
	@echo "All objects: $(ALL_OBJS)"

.PHONY: all clean run debug

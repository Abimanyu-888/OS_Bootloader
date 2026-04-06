# Variables for our compilers and flags
CC = gcc
CFLAGS = -m32 -ffreestanding -fno-pie -c
LD = ld
LDFLAGS = -m elf_i386 -Ttext 0x1000 --oformat binary

# The default target that runs when you just type 'make'
all: run

# 1. Compile the C kernel into an object file
kernel.o: kernel.c
	$(CC) $(CFLAGS) kernel.c -o kernel.o

# 2. Compile the kernel entry assembly into an ELF object file
kernel_entry.o: kernel_entry.asm
	nasm -f elf kernel_entry.asm -o kernel_entry.o

# 3. Link the entry and the C code into a single binary kernel
kernel.bin: kernel_entry.o kernel.o
	$(LD) $(LDFLAGS) kernel_entry.o kernel.o -o kernel.bin

# 4. Compile the bootsector
bootsect.bin: bootsect.asm
	nasm -f bin bootsect.asm -o bootsect.bin

# 5. Glue the bootsector and kernel together into the final image
os_image.bin: bootsect.bin kernel.bin
	cat bootsect.bin kernel.bin > os_image.bin

# Run the OS in QEMU
run: os_image.bin
	qemu-system-x86_64 -drive format=raw,file=os_image.bin

# Clean up all the generated files so we can start fresh
clean:
	rm -f *.bin *.o

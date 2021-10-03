C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)

# convert the *.c filenames to *.o to give a list of objects files to build
OBJ = ${C_SOURCES:.c=.o}
# debug
CFLAGS = -g

# actual disk image that the computer loads
os-image.bin: boot/bootsect.bin kernel.bin
	cat $^ > os-image.bin

# kernel_entry jumps to main() in kernel
kernel.bin: boot/kernel_entry.o ${OBJ}
	ld -o $@ -Ttext 0x1000 $^ --oformat binary

# used for debugging purposes
kernel.elf: boot/kernel_entry.o ${OBJ}
	ld -o $@ -Ttext 0x1000 $^

run: os-image.bin
	qemu-system-x86_64 os-image.bin

# open the connection to qemu and load our kernel-object file with symbols
debug: os-image.bin kernel.elf
	qemu-system-x86_64 -s os-image.bin &
	gdb -ex "target remote localhost:1234" -ex "symbol-file kernel.elf"

# generic rule for compile 
# for simplicity, we C files depend on all header files
%.o : %.c ${HEADERS}
	gcc ${CFLAGS} -ffreestanding -c $< -o $@

# assemble the kernel_entry
%.o : %.asm
	nasm $< -f elf64 -o $@

%.bin : %.asm
	nasm $< -f bin -o $@

clean:
	rm -rf *.bin *.dis *.o os-image.bin *.elf
	rm -rf kernel/*.o boot/*.bin drivers/*.o boot/*.o
AS=nasm
ASFLAGS=-f elf64 -g
CC=gcc
CFLAGS=-no-pie

SOURCES=project2_main.asm project2_lib.asm
OBJECTS=$(SOURCES:.asm=.o)
EXECUTABLE=project2_demo

all: $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(CFLAGS) $(OBJECTS) -o $@

%.o: %.asm
	$(AS) $(ASFLAGS) $< -o $@

run: $(EXECUTABLE)
	./$(EXECUTABLE)

clean:
	rm -f *.o $(EXECUTABLE)

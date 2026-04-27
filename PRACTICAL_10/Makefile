AS=nasm
ASFLAGS=-f elf64 -g
CC=gcc
CFLAGS=-no-pie

DEMO=project2_demo
TESTS=project2_tests

DEMO_OBJECTS=project2_main.o project2_lib.o
TEST_OBJECTS=test_project2.o project2_lib.o

all: $(DEMO) $(TESTS)

$(DEMO): $(DEMO_OBJECTS)
	$(CC) $(CFLAGS) $(DEMO_OBJECTS) -o $@

$(TESTS): $(TEST_OBJECTS)
	$(CC) $(CFLAGS) $(TEST_OBJECTS) -o $@

%.o: %.asm
	$(AS) $(ASFLAGS) $< -o $@

%.o: %.c
	$(CC) -Wall -Wextra -std=c11 -g -c $< -o $@

run: $(DEMO)
	./$(DEMO)

test: $(TESTS)
	./$(TESTS)

clean:
	rm -f *.o $(DEMO) $(TESTS)

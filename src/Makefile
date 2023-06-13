CC := gcc
GNUSTEP_LIBS = $(shell gnustep-config --base-libs)
GNUSTEP_FLAGS = $(shell gnustep-config --objc-flags)

CURSES = -D_DEFAULT_SOURCE -D_XOPEN_SOURCE=600 -lncursesw

.PHONY = clean all

PROGS = cpu

cpu: cpu.m cpu.h alu.o bus.o register.o mem.o umem.o parser.o screen.o
	$(CC) $(GNUSTEP_FLAGS) alu.o bus.o register.o mem.o umem.o parser.o screen.o -o cpu cpu.m $(GNUSTEP_LIBS) $(CURSES)

alu.o: alu.m alu.h
	$(CC) $(GNUSTEP_FLAGS) -c -o alu.o alu.m

register.o: register.m register.h
	$(CC) $(GNUSTEP_FLAGS) -c -o register.o register.m

bus.o: bus.m bus.h
	$(CC) $(GNUSTEP_FLAGS) -c -o bus.o bus.m

mem.o: mem.m mem.h
	$(CC) $(GNUSTEP_FLAGS) -c -o mem.o mem.m

umem.o: umem.m umem.h
	$(CC) $(GNUSTEP_FLAGS) -c -o umem.o umem.m

parser.o: parser.m
	$(CC) $(GNUSTEP_FLAGS) -c -o parser.o parser.m

screen.o: screen.m
	$(CC) $(GNUSTEP_FLAGS) -c -o screen.o screen.m

clean:
	rm *.o $(PROGS)

# CC=i386-elf-gcc
CC=clang
LD=i386-elf-ld
OBJCOPY=i386-elf-objcopy
NM=i386-elf-nm

CFLAGS=-D__PRE_RAM__
CFLAGS+=-I. -nostdlib -static -ffreestanding
CFLAGS+=-target i386-linux-elf -m32
LDFLAGS=-T testcase.ld
OBJ = testcase.o

%.o: %.c
	@printf "    COMPILE..\n"
		@$(CC) -c -o $@ $< $(CFLAGS)

testcase: $(OBJ)
	@printf "    LINK..\n"
		@$(LD) -o $@ $^ $(LDFLAGS)
	@printf "    RESULTS..\n"
		@$(OBJCOPY) --only-section .illegal_globals $(@) romstage_null.offenders && \
			$(NM) romstage_null.offenders | grep -q " [DdBb] "; if [ $$? -eq 0 ]; then \
			echo "Forbidden global variables in romstage:"; \
			$(NM) romstage_null.offenders | grep " [DdBb] "; \
			else true; fi

.PHONY: clean

clean:
		rm -f $(OBJ) testcase

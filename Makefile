CC=clang
LD=ld
OBJCOPY=objcopy
NM=nm

CFLAGS=-nostdlib -static -ffreestanding  -target i386-linux-elf -m32
LDFLAGS=-T testcase.ld
OBJ = testcase.o

%.o: %.c
	@printf "    COMPILE..\n"
		$(CC) -c -o $@ $< $(CFLAGS)

testcase: $(OBJ)
	@printf "    LINK..\n"
		$(LD) -o $@ $^ $(LDFLAGS)
	@printf "    DETAILS..\n"
	$(OBJCOPY) --only-section .illegal_globals $(@) romstage_null.offenders && \
		$(NM) romstage_null.offenders | grep -q " [DdBb] "; if [ $$? -eq 0 ]; then \
		echo "Forbidden global variables in romstage:"; \
		$(NM) romstage_null.offenders | grep " [DdBb] "; \
		else true; fi

.PHONY: clean

clean:
		rm -f $(OBJ) testcase

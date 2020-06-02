AS = as
LD = ld
ASFLAGS = -g
LDFLAGS = -static
HEADERS = defs.h
EXECUTABLES = exit samduren envtruth

.PHONY: all clean

all: $(EXECUTABLES)

$(EXECUTABLES): %: %.o
	$(LD) $(LDFLAGS) -o $@ $<

%.o: %.s $(HEADRES)
	$(AS) $(ASFLAGS) -o $@ -c $<

clean:
	rm -f $(EXECUTABLES)
	rm -f *.o
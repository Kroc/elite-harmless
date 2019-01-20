#
# Makefile for perf
#
WFLAGS = -std=c89 -Wall -Wstrict-prototypes -D_XOPEN_SOURCE=600 -pedantic
CFLAGS = $(WFLAGS) -O3 -ffast-math -fomit-frame-pointer
LDFLAGS = -s

#CFLAGS = -g -mtune=i686 $(WFLAGS)
#LDFLAGS = -g -mtune=i686

DECR_OBJS = ../exodecrunch.os
DECR_OBJSP+16 = ../exodecrunch.osP+16
DECR_OBJSM256 = ../exodecrunch.osM256
DECR_OBJSi = ../exodecrunch.osi
DECR_OBJSiM256 = ../exodecrunch.osiM256
CRUNCHER = ../../src/exomizer mem -P7 -q $<@0x1010 -o $@
CRUNCHERP+16 = ../../src/exomizer mem -P+16 -q $<@0x1010 -o $@
CRUNCHERM256 = ../../src/exomizer mem -M256 -q $<@0x1010 -o $@

TEST_OBJS = ../testrun.o ../../src/6502emu.o ../../src/exo_util.o ../../src/log.o ../../src/areatrace.o ../../src/vec.o ../../src/membuf_io.o ../../src/membuf.o

OBJS = ../main.os $(DECR_OBJS)
OBJSP+16 = ../main.os $(DECR_OBJSP+16)
OBJSi = ../main.os $(DECR_OBJSi)
OBJSM256 = ../main.os $(DECR_OBJSM256)
OBJSiM256 = ../main.os $(DECR_OBJSiM256)


.PHONY: build %.test %.stat
.PRECIOUS: %.cru %.cruM256 %.prg $(TEST_OBJS) %.cru.out %.cruM256.out
#.INTERMEDIATE: %.cru.out

build: data.test
#
# make <prefix>.stat shows statistics for all files that match <prefix>*.raw
# together with average statistics for all files that matched.
#
# use .stat for jsr getbit decruncher
# use .stati for inlined getbit decruncher
# use .statM256 for a decruncher with sequence length <= 256
# use .statiM256 for inlined getbit decruncher with sequence length <= 256
#
%.stat:	test.prg ../testrun
	@$(MAKE) $(sort $(patsubst %.raw,%.cru,$(wildcard $**.raw)))
	@../testrun test.prg $(sort $(patsubst %.raw,%.cru,$(wildcard $**.raw)))

%.statP+16:	test.prgP+16 ../testrun
	@$(MAKE) $(sort $(patsubst %.raw,%.cruP+16,$(wildcard $**.raw)))
	@../testrun test.prgP+16 $(sort $(patsubst %.raw,%.cruP+16,$(wildcard $**.raw)))

%.stati:	test.prgi ../testrun
	@$(MAKE) $(sort $(patsubst %.raw,%.crui,$(wildcard $**.raw)))
	@../testrun test.prgi $(sort $(patsubst %.raw,%.crui,$(wildcard $**.raw)))

%.statM256:	test.prgM256 ../testrun
	@$(MAKE) $(sort $(patsubst %.raw,%.cruM256,$(wildcard $**.raw)))
	@../testrun test.prgM256 $(sort $(patsubst %.raw,%.cruM256,$(wildcard $**.raw)))

%.statiM256:	test.prgiM256 ../testrun
	@$(MAKE) $(sort $(patsubst %.raw,%.cruiM256,$(wildcard $**.raw)))
	@../testrun test.prgiM256 $(sort $(patsubst %.raw,%.cruiM256,$(wildcard $**.raw)))

../testrun: $(TEST_OBJS)
	@echo "Linking $@"
	@$(CC) $(LDFLAGS) -o $@ $(TEST_OBJS)

%.test: %.cru.out %.raw
	cmp $< $*.raw

%.testP+16: %.cruP+16.out %.raw
	cmp $< $*.raw

%.testi: %.crui.out %.raw
	cmp $< $*.raw

%.testM256: %.cruM256.out %.raw
	cmp $< $*.raw

%.testiM256: %.cruiM256.out %.raw
	cmp $< $*.raw

%.cru.out: test.prg %.cru ../testrun
	../testrun $< $*.cru

%.cruP+16.out: test.prgP+16 %.cruP+16 ../testrun
	../testrun $< $*.cruP+16

%.cruM256.out: test.prgM256 %.cruM256 ../testrun
	../testrun $< $*.cruM256

%.crui.out: testi.prg %.crui ../testrun
	../testrun $< $*.crui

%.cruiM256.out: test.prgiM256 %.cruiM256 ../testrun
	../testrun $< $*.cruiM256

%.prg: $(OBJS) ../c64.cfg
	ld65 $(OBJS) -o $@ -C../c64.cfg

%.prgP+16: $(OBJSP+16) ../c64.cfg
	ld65 $(OBJSP+16) -o $@ -C../c64.cfg

%.prgi: $(OBJSi) ../c64.cfg
	ld65 $(OBJSi) -o $@ -C../c64.cfg

%.prgM256: $(OBJSM256) ../c64.cfg
	ld65 $(OBJSM256) -o $@ -C../c64.cfg

%.prgiM256: $(OBJSiM256) ../c64.cfg
	ld65 $(OBJSiM256) -o $@ -C../c64.cfg

%.os: %.s
	ca65 $< -o $@

%.osP+16: %.s
	ca65 -DEXTRA_TABLE_ENTRY_FOR_LENGTH_THREE=1 $< -o $@

%.osi: %.s
	ca65 -DINLINE_GET_BITS=1 $< -o $@

%.osM256: %.s
	ca65 -DMAX_SEQUENCE_LENGTH_M256=1 $< -o $@

%.osiM256: %.s
	ca65 -DINLINE_GET_BITS=1 -DMAX_SEQUENCE_LENGTH_M256=1 $< -o $@

clean:
	$(RM) *.out *.cru* test*.prg*

%.cru: %.raw
	$(CRUNCHER)

%.cruP+16: %.raw
	$(CRUNCHERP+16)

%.cruM256: %.raw
	$(CRUNCHERM256)

%.crui: %.cru
	cp $< $@

%.cruiM256: %.cruM256
	cp $< $@

%.o:	%.c
	@echo "Compiling $<"
	@$(CC) -c $(CFLAGS) $(CPPFLAGS) -o $@ $<

%:	%.o
	@$(CC) $(LDFLAGS) $< -o $@

# cancel built in rule that disturb things
%.out: %

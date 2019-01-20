#
# Makefile for testrun
#
WFLAGS = -std=c89 -Wall -Wstrict-prototypes -D_XOPEN_SOURCE=600 -pedantic
CFLAGS = $(WFLAGS) -O3 -ffast-math -fomit-frame-pointer
LDFLAGS = -s

#CFLAGS = -g $(WFLAGS)
#LDFLAGS = -g

TEST_OBJS = ../src/6502emu.o ../src/exo_util.o ../src/log.o ../src/areatrace.o ../src/vec.o ../src/membuf_io.o ../src/membuf.o

SOURCES = main.os exodecrunch.os
SOURCES256 = main.os exodecrunch.os256
SOURCESc = main.os exodecrunch.osc
SOURCES256c = main.os exodecrunch.os256c
SOURCESi = main.os exodecrunch.osi
SOURCESi256 = main.os exodecrunch.osi256
SOURCESic = main.os exodecrunch.osic
SOURCESi256c = main.os exodecrunch.osi256c
SOURCESF = mainf.os krilldecr.os
SOURCES1 = main1.os exostreamdecr1.os
SOURCES2 = main2.os exostreamdecr2.os
NAME = test.prg
NAME256 = test256.prg
NAMEc = testc.prg
NAME256c = test256c.prg
NAMEi = testi.prg
NAMEi256 = testi256.prg
NAMEic = testic.prg
NAMEi256c = testi256c.prg
NAMEF = testf.prg
NAME1 = test1.prg
NAME2 = test2.prg

.PRECIOUS: %.exo %.prg $(TEST_OBJS)
.INTERMEDIATE: %.exo.out

build: $(NAME) $(NAME256) $(NAMEc) $(NAME256c) $(NAMEi) $(NAMEi256) $(NAMEic) $(NAMEi256c) $(NAMEF) $(NAME1) $(NAME2)

testrun: testrun.o $(TEST_OBJS)
	@echo "Linking $@"
	@$(CC) $(LDFLAGS) -o $@ testrun.o $(TEST_OBJS)

$(NAME): $(MAKEFILE) testrun data.exo $(SOURCES)
	ld65 $(SOURCES) -o $@ -Cc64.cfg
	./testrun $@ data.exo
	cmp -i0:2 data.exo.out data.bin && $(RM) data.exo.out

$(NAME256): $(MAKEFILE) testrun data256.exo $(SOURCES256)
	ld65 $(SOURCES256) -o $@ -Cc64.cfg
	./testrun $@ data256.exo
	cmp -i0:2 data256.exo.out data.bin && $(RM) data256.exo.out

$(NAMEc): $(MAKEFILE) testrun datac.exo $(SOURCESc)
	ld65 $(SOURCESc) -o $@ -Cc64.cfg
	./testrun $@ datac.exo
	cmp -i0:2 datac.exo.out data.bin && $(RM) datac.exo.out

$(NAME256c): $(MAKEFILE) testrun data256c.exo $(SOURCES256c)
	ld65 $(SOURCES256c) -o $@ -Cc64.cfg
	./testrun $@ data256c.exo
	cmp -i0:2 data256c.exo.out data.bin && $(RM) data256c.exo.out

$(NAMEi): $(MAKEFILE) testrun data.exo $(SOURCESi)
	ld65 $(SOURCESi) -o $@ -Cc64.cfg
	./testrun $@ data.exo
	cmp -i0:2 data.exo.out data.bin && $(RM) data.exo.out

$(NAMEi256): $(MAKEFILE) testrun data256.exo $(SOURCESi256)
	ld65 $(SOURCESi256) -o $@ -Cc64.cfg
	./testrun $@ data256.exo
	cmp -i0:2 data256.exo.out data.bin && $(RM) data256.exo.out

$(NAMEic): $(MAKEFILE) testrun datac.exo $(SOURCESic)
	ld65 $(SOURCESic) -o $@ -Cc64.cfg
	./testrun $@ datac.exo
	cmp -i0:2 datac.exo.out data.bin && $(RM) datac.exo.out

$(NAMEi256c): $(MAKEFILE) testrun data256c.exo $(SOURCESi256c)
	ld65 $(SOURCESi256c) -o $@ -Cc64.cfg
	./testrun $@ data256c.exo
	cmp -i0:2 data256c.exo.out data.bin && $(RM) data256c.exo.out

$(NAMEF): $(MAKEFILE) testrun dataf.exo $(SOURCESF)
	ld65 $(SOURCESF) -o $@ -Cc64.cfg
	./testrun $@ dataf.exo
	cmp -i0:2 dataf.exo.out data.bin && $(RM) dataf.exo.out

$(NAME1): $(MAKEFILE) testrun streamdata.exo $(SOURCES1)
	ld65 $(SOURCES1) -o $@ -Cc64.cfg
	./testrun $@ streamdata.exo@0x3000
	cmp -i0:2 streamdata.exo.out data.bin && $(RM) streamdata.exo.out

$(NAME2): $(MAKEFILE) testrun streamdata.exo $(SOURCES2)
	ld65 $(SOURCES2) -o $@ -Cc64.cfg
	./testrun $@ streamdata.exo@0x3000
	cmp -i0:2 streamdata.exo.out data.bin && $(RM) streamdata.exo.out

%.os: %.s
	ca65 $< -o $@

%.os256c: %.s
	ca65 -DLITERAL_SEQUENCES_NOT_USED=1 -DMAX_SEQUENCE_LENGTH_256=1 $< -o $@

%.os256: %.s
	ca65 -DMAX_SEQUENCE_LENGTH_256=1 $< -o $@

%.osc: %.s
	ca65 -DLITERAL_SEQUENCES_NOT_USED=1 $< -o $@

%.osi: %.s
	ca65 -DINLINE_GET_BITS=1 $< -o $@

%.osi256c: %.s
	ca65 -DINLINE_GET_BITS=1 -DLITERAL_SEQUENCES_NOT_USED=1 -DMAX_SEQUENCE_LENGTH_256=1 $< -o $@

%.osi256: %.s
	ca65 -DINLINE_GET_BITS=1 -DMAX_SEQUENCE_LENGTH_256=1 $< -o $@

%.osic: %.s
	ca65 -DINLINE_GET_BITS=1 -DLITERAL_SEQUENCES_NOT_USED=1 $< -o $@
clean:
	$(RM) testrun.o test*.prg *.os* *.exo *.exo.out testrun

data.exo: data.bin
	../src/exomizer mem -q -C data.bin,0x3000 -o data.exo

data256.exo: data.bin
	../src/exomizer mem -q -M256 -C data.bin,0x3000 -o data256.exo

datac.exo: data.bin
	../src/exomizer mem -q -c -C data.bin,0x3000 -o datac.exo

data256c.exo: data.bin
	../src/exomizer mem -q -M256 -c -C data.bin,0x3000 -o data256c.exo

dataf.exo: data.bin
	../src/exomizer mem -q -C -P0 -f data.bin,0x3000 -o dataf.exo

streamdata.exo: data.bin
	../src/exomizer raw -q -C -P0 -b -c -m 1024 data.bin,2 -o streamdata.exo

%.o:	%.c
	@echo "Compiling $<"
	@$(CC) -c $(CFLAGS) $(CPPFLAGS) -o $@ $<

%:	%.o
	@$(CC) $(LDFLAGS) $< -o $@

# cancel built in rule that disturb things
%.out: %

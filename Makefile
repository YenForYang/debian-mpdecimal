
# ==============================================================================
#                          Unix Makefile for libmpdec
# ==============================================================================


LIBSTATIC = libmpdec.a
LIBSONAME = libmpdec.so.2
LIBSHARED = libmpdec.so.2.4.2

CC = icc.pl
LD = icc.pl
AR = xiar.pl
RANLIB = ranlib
MPD_PGEN = -wd11505 -prof-gen
MPD_PUSE = -wd11505 -prof-use
MPD_PREC = 19
MPD_DPREC = 38

CONFIGURE_CFLAGS = -Wall -Wno-unknown-pragmas -DCONFIG_64 -DASM -O2 -g -O2 -fdebug-prefix-map=/dev/shm/mpdecimal/mpdecimal-2.4.2=. -Wformat -march=native -pipe -Wformat-security
MPD_CFLAGS = $(strip $(CONFIGURE_CFLAGS) $(CFLAGS))

CONFIGURE_LDFLAGS = 
MPD_LDFLAGS = $(strip $(CONFIGURE_LDFLAGS) $(LDFLAGS))

ifeq ($(MAKECMDGOALS), profile_gen)
  MPD_CFLAGS += $(MPD_PGEN)
  MPD_LDFLAGS += $(MPD_PGEN)
endif
ifeq ($(MAKECMDGOALS), profile_use)
  MPD_CFLAGS += $(MPD_PUSE)
  MPD_LDFLAGS += $(MPD_PUSE)
endif

MPD_CFLAGS_SHARED = $(MPD_CFLAGS) -fPIC

ifeq ($(shell uname), Darwin)
  MPD_SOFLAGS=-dynamiclib -Wl,-install_name,$(LIBSONAME)
else
  MPD_SOFLAGS=-shared -Wl,-soname,$(LIBSONAME)
endif


default: $(LIBSTATIC) $(LIBSHARED)

CSRCFILES := basearith.c constants.c context.c convolute.c crt.c difradix2.c fnt.c fourstep.c io.c memory.c mpdecimal.c mpsignal.c numbertheory.c sixstep.c transpose.c

OBJS := basearith.o context.o constants.o convolute.o crt.o mpdecimal.o \
        mpsignal.o difradix2.o fnt.o fourstep.o io.o memory.o numbertheory.o \
        sixstep.o transpose.o

BIGOBJ := ipo_out.o

SHARED_OBJS := .objs/basearith.o .objs/context.o .objs/constants.o \
               .objs/convolute.o .objs/crt.o .objs/mpdecimal.o .objs/mpsignal.o \
               .objs/difradix2.o .objs/fnt.o .objs/fourstep.o .objs/io.o \
               .objs/memory.o .objs/numbertheory.o .objs/sixstep.o \
               .objs/transpose.o

#$(LIBSTATIC): Makefile $(OBJS)
$(LIBSTATIC): Makefile $(BIGOBJ)
	$(AR) rc $(LIBSTATIC) $(OBJS)
	$(RANLIB) $(LIBSTATIC)

$(LIBSHARED): Makefile $(SHARED_OBJS)
	$(LD) $(MPD_CFLAGS_SHARED) $(MPD_LDFLAGS) $(MPD_SOFLAGS) -o $(LIBSHARED) $(CSRCFILES) -lm
	ln -sf $(LIBSHARED) libmpdec.so
	ln -sf $(LIBSHARED) $(LIBSONAME)

ipo_out.o:\
Makefile $(CSRCFILES)
	$(CC) $(MPD_CFLAGS) -no-inline-total-max-size -ipo-c $(CSRCFILES)

#basearith.o:\
#makefile basearith.c mpdecimal.h constants.h memory.h \
#typearith.h basearith.h
#	$(CC) $(MPD_CFLAGS) -c basearith.c
#
#.objs/basearith.o:\
#makefile basearith.c mpdecimal.h constants.h memory.h \
#typearith.h basearith.h
#	$(CC) $(MPD_CFLAGS_SHARED) -c basearith.c -o .objs/basearith.o
#
#constants.o:\
#makefile constants.c mpdecimal.h constants.h
#	$(CC) $(MPD_CFLAGS) -c constants.c
#
#.objs/constants.o:\
#makefile constants.c mpdecimal.h constants.h
#	$(CC) $(MPD_CFLAGS_SHARED) -c constants.c -o .objs/constants.o
#
#context.o:\
#makefile context.c mpdecimal.h
#	$(CC) $(MPD_CFLAGS) -c context.c
#
#.objs/context.o:\
#makefile context.c mpdecimal.h
#	$(CC) $(MPD_CFLAGS_SHARED) -c context.c -o .objs/context.o
#
#convolute.o:\
#makefile convolute.c mpdecimal.h bits.h constants.h fnt.h fourstep.h \
#numbertheory.h sixstep.h umodarith.h typearith.h convolute.h
#	$(CC) $(MPD_CFLAGS) -c convolute.c
#
#.objs/convolute.o:\
#makefile convolute.c mpdecimal.h bits.h constants.h fnt.h fourstep.h \
#numbertheory.h sixstep.h umodarith.h typearith.h convolute.h
#	$(CC) $(MPD_CFLAGS_SHARED) -c convolute.c -o .objs/convolute.o
#
#crt.o:\
#makefile crt.c mpdecimal.h numbertheory.h constants.h umodarith.h \
#typearith.h crt.h
#	$(CC) $(MPD_CFLAGS) -c crt.c
#
#.objs/crt.o:\
#makefile crt.c mpdecimal.h numbertheory.h constants.h umodarith.h \
#typearith.h crt.h
#	$(CC) $(MPD_CFLAGS_SHARED) -c crt.c -o .objs/crt.o
#
#difradix2.o:\
#makefile difradix2.c mpdecimal.h bits.h numbertheory.h constants.h \
#umodarith.h typearith.h difradix2.h
#	$(CC) $(MPD_CFLAGS) -c difradix2.c
#
#.objs/difradix2.o:\
#makefile difradix2.c mpdecimal.h bits.h numbertheory.h constants.h \
#umodarith.h typearith.h difradix2.h
#	$(CC) $(MPD_CFLAGS_SHARED) -c difradix2.c -o .objs/difradix2.o
#
#fnt.o:\
#makefile fnt.c mpdecimal.h bits.h difradix2.h numbertheory.h \
#constants.h fnt.h
#	$(CC) $(MPD_CFLAGS) -c fnt.c
#
#.objs/fnt.o:\
#makefile fnt.c mpdecimal.h bits.h difradix2.h numbertheory.h \
#constants.h fnt.h
#	$(CC) $(MPD_CFLAGS_SHARED) -c fnt.c -o .objs/fnt.o
#
#fourstep.o:\
#makefile fourstep.c mpdecimal.h numbertheory.h constants.h sixstep.h \
#transpose.h umodarith.h typearith.h fourstep.h
#	$(CC) $(MPD_CFLAGS) -c fourstep.c
#
#.objs/fourstep.o:\
#makefile fourstep.c mpdecimal.h numbertheory.h constants.h sixstep.h \
#transpose.h umodarith.h typearith.h fourstep.h
#	$(CC) $(MPD_CFLAGS_SHARED) -c fourstep.c -o .objs/fourstep.o
#
#io.o:\
#makefile io.c mpdecimal.h bits.h constants.h memory.h typearith.h io.h
#	$(CC) $(MPD_CFLAGS) -c io.c
#
#.objs/io.o:\
#makefile io.c mpdecimal.h bits.h constants.h memory.h typearith.h io.h
#	$(CC) $(MPD_CFLAGS_SHARED) -c io.c -o .objs/io.o
#
#memory.o:\
#makefile memory.c mpdecimal.h typearith.h memory.h
#	$(CC) $(MPD_CFLAGS) -c memory.c
#
#.objs/memory.o:\
#makefile memory.c mpdecimal.h typearith.h memory.h
#	$(CC) $(MPD_CFLAGS_SHARED) -c memory.c -o .objs/memory.o
#
#mpdecimal.o:\
#makefile mpdecimal.c mpdecimal.h basearith.h typearith.h bits.h \
#convolute.h crt.h memory.h umodarith.h constants.h
#	$(CC) $(MPD_CFLAGS) -c mpdecimal.c
#
#.objs/mpdecimal.o:\
#makefile mpdecimal.c mpdecimal.h basearith.h typearith.h bits.h \
#convolute.h crt.h memory.h umodarith.h constants.h
#	$(CC) $(MPD_CFLAGS_SHARED) -c mpdecimal.c -o .objs/mpdecimal.o
#
#mpsignal.o:\
#makefile mpdecimal.c mpdecimal.h
#	$(CC) $(MPD_CFLAGS) -c mpsignal.c
#
#.objs/mpsignal.o:\
#makefile mpdecimal.c mpdecimal.h
#	$(CC) $(MPD_CFLAGS_SHARED) -c mpsignal.c -o .objs/mpsignal.o
#
#numbertheory.o:\
#makefile numbertheory.c mpdecimal.h bits.h umodarith.h constants.h \
#typearith.h numbertheory.h
#	$(CC) $(MPD_CFLAGS) -c numbertheory.c
#
#.objs/numbertheory.o:\
#makefile numbertheory.c mpdecimal.h bits.h umodarith.h constants.h \
#typearith.h numbertheory.h
#	$(CC) $(MPD_CFLAGS_SHARED) -c numbertheory.c -o .objs/numbertheory.o
#
#sixstep.o:\
#makefile sixstep.c mpdecimal.h bits.h difradix2.h numbertheory.h \
#constants.h transpose.h umodarith.h typearith.h sixstep.h
#	$(CC) $(MPD_CFLAGS) -c sixstep.c
#
#.objs/sixstep.o:\
#makefile sixstep.c mpdecimal.h bits.h difradix2.h numbertheory.h \
#constants.h transpose.h umodarith.h typearith.h sixstep.h
#	$(CC) $(MPD_CFLAGS_SHARED) -c sixstep.c -o .objs/sixstep.o
#
#transpose.o:\
#makefile transpose.c mpdecimal.h bits.h constants.h typearith.h \
#transpose.h
#	$(CC) $(MPD_CFLAGS) -c transpose.c
#
#.objs/transpose.o:\
#makefile transpose.c mpdecimal.h bits.h constants.h typearith.h \
#transpose.h
#	$(CC) $(MPD_CFLAGS_SHARED) -c transpose.c -o .objs/transpose.o
#

FORCE:

bench: FORCE $(LIBSTATIC)
	$(CC) -Wno-unused-but-set-variable $(MPD_CFLAGS) -o bench bench.c $(LIBSTATIC) -lm

bench_shared: FORCE $(LIBSHARED)
	$(CC) -L. -Wno-unused-but-set-variable $(MPD_CFLAGS) -o bench_shared bench.c -lmpdec -lm


profile_gen: clean bench bench_shared
	./bench $(MPD_PREC) 1000
	./bench $(MPD_DPREC) 1000
	LD_LIBRARY_PATH=. ./bench_shared $(MPD_PREC) 1000
	LD_LIBRARY_PATH=. ./bench_shared $(MPD_DPREC) 1000
	rm -f *.o *.gch .objs/*.o .objs/*.gch bench bench_shared
	rm -f $(LIBSTATIC) $(LIBSHARED) $(LIBSONAME) libmpdec.so

profile_use: bench bench_shared
	./bench $(MPD_PREC) 1000
	./bench $(MPD_DPREC) 1000
	LD_LIBRARY_PATH=. ./bench_shared $(MPD_PREC) 1000
	LD_LIBRARY_PATH=. ./bench_shared $(MPD_DPREC) 1000

profile:
	$(MAKE) profile_gen
	$(MAKE) profile_use

clean: FORCE
	rm -f *.o *.so *.gch *.gcda *.gcno *.gcov *.dyn *.dpi *.lock
	rm -f bench bench_shared $(LIBSTATIC) $(LIBSHARED) $(LIBSONAME) libmpdec.so
	cd .objs && rm -f *.o *.so *.gch *.gcda *.gcno *.gcov *.dyn *.dpi *.lock

distclean: clean
	rm -f config.h config.log config.status Makefile mpdecimal.h




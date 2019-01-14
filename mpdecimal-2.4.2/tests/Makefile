
SRCDIR = ../libmpdec

CC = icc.pl -std=gnu89
LD = icc.pl -std=gnu89
AR = xiar

LIBSTATIC = libmpdec.a
LIBSHARED = libmpdec.so.2.4.2

MPD_WARN = -Wall -Wno-unknown-pragmas
MPD_CONFIG = -DCONFIG_64 -DASM

CONFIGURE_CFLAGS = -Wall -Wno-unknown-pragmas -DCONFIG_64 -DASM -O2 -g -O2 -fdebug-prefix-map=/dev/shm/mpdecimal/mpdecimal-2.4.2=. -Wformat -march=native -pipe -Wformat-security
CFLAGS ?= $(CONFIGURE_CFLAGS)


default: runtest runtest_shared runtest_alloc runtest_alloc_shared


# Short test.
runtest:\
Makefile runtest.c $(SRCDIR)/io.h $(SRCDIR)/mpdecimal.h $(SRCDIR)/memory.h \
malloc_fail.c malloc_fail.h mptest.h $(SRCDIR)/$(LIBSTATIC)
	$(CC) -I$(SRCDIR) $(CFLAGS) -o runtest runtest.c malloc_fail.c $(SRCDIR)/libmpdec.a -lm

runtest_shared:\
Makefile runtest.c $(SRCDIR)/io.h $(SRCDIR)/mpdecimal.h $(SRCDIR)/memory.h \
malloc_fail.c malloc_fail.h mptest.h $(SRCDIR)/$(LIBSHARED)
	$(CC) -I$(SRCDIR) -L$(SRCDIR) $(CFLAGS) -o runtest_shared runtest.c malloc_fail.c -lmpdec -lm

# Also test all allocation failures.
runtest_alloc:\
Makefile runtest.c $(SRCDIR)/io.h $(SRCDIR)/mpdecimal.h $(SRCDIR)/memory.h \
malloc_fail.c malloc_fail.h mptest.h $(SRCDIR)/$(LIBSTATIC)
	$(CC) -I$(SRCDIR) $(CFLAGS) -DTEST_ALLOC -o runtest_alloc runtest.c malloc_fail.c $(SRCDIR)/libmpdec.a -lm

runtest_alloc_shared:\
Makefile runtest.c $(SRCDIR)/io.h $(SRCDIR)/mpdecimal.h $(SRCDIR)/memory.h \
malloc_fail.c malloc_fail.h mptest.h $(SRCDIR)/$(LIBSHARED)
	$(CC) -I$(SRCDIR) -L$(SRCDIR) $(CFLAGS) -DTEST_ALLOC -o runtest_alloc_shared runtest.c malloc_fail.c -lmpdec -lm


FORCE:

clean: FORCE
	rm -f *.o *.gch *.gcda *.gcno *.gcov *.dyn *.dpi *.lock
	rm -f runtest runtest_shared runtest_alloc runtest_alloc_shared

distclean: FORCE
	$(MAKE) clean
	rm -rf Makefile dectest.zip testdata



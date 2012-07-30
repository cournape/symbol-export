CC = gcc
LD = gcc
CFLAGS = -W -Wall -fPIC
# Macho version
LIBFOO_LDFLAGS = -dynamiclib #-exported_symbols_list export.list
# ELF version
#LIBFOO_LDFLAGS = -shared  #-Wl,--version-script=foo.version
AR = ar

main: main.o libfoo.so
	$(LD) -o $@ $< -L. -lfoo

# This fails at link time if the version script is enabled
private_main: private_main.o libfoo.so
	$(LD) -o $@ $< -L. -lfoo

libfoo.so: foo.o libprivate_foo.a
	$(LD) -o $@ $< -L. -lprivate_foo $(LIBFOO_LDFLAGS)

libprivate_foo.a: private_foo.o
	ar rc $@ $<

%.o: %.c
	$(CC) -c $< -o $@ $(CFLAGS)

clean:
	rm -f *.o
	rm -f libfoo.so
	rm -f libprivate_foo.a
	rm -f main
	rm -f private_main

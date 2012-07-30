This small projects illustrates symbols 'leaking'::

        - the (static) library libprivate_foo.a contains a private_foo function
        - the (shared) library libfoo.so contains a foo function, that internally uses private_foo
        - the executable main links libfoo.so and only uses the function foo
        - the executable private_main links libfoo.so and uses both function foo and private_foo

If you do::

        make main private_main

with the default link flags, it will build and link correctly. The symbol
private_foo is leaked through libfoo.so::

        nm libfoo.so

returns::

        0000000000000ee0 T _foo
        0000000000000f10 T _private_foo
                         U dyld_stub_binder

where the upper case signals non-local symbols.

If the -exported_symbol_list/--version-script part of LIBFOO_LDFLAGS is
uncommented, and everything is rebuilt::

        make clean && make main private_main

private_main will fail to link, as libfoo.so does not export private_foo. This
can confirmed by nm libfoo.so::

        nm libfoo.so

returns::

        0000000000000ee0 T _foo
        0000000000000f10 t _private_foo
                         U dyld_stub_binder

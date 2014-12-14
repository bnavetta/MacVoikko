#!/bin/sh

ROOT="$PWD"
HFST_PREFIX="$PWD/hfst-code/hfst-ospell"
export HFSTOSPELL_CFLAGS="-I$HFST_PREFIX"
export HFSTOSPELL_LIBS="-L$HFST_PREFIX -lhfstospell"

cd corevoikko/libvoikko

[[ -f configure ]] || ./autogen.sh
./configure --enable-hfst
make

cp src/.libs/libvoikko.a "$ROOT/libs"

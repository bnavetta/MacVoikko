#!/bin/sh

ROOT="$PWD"

export LIBXMLPP_CFLAGS="-I/usr/local/include/libxml++-2.6 -I/usr/local/lib/libxml++-2.6/include -I/usr/local/lib/glibmm-2.4/include -I/usr/local/include/glibmm-2.4/ -I/usr/local/include/glib-2.0 -I/usr/local/lib/glib-2.0/include"
export LIBXMLPP_LIBS="-L/usr/local/lib -lxml++-2.6 -lglibmm-2.4"

export LIBARCHIVE_CFLAGS="-I/usr/local/opt/libarchive/include"
export LIBARCHIVE_LIBS="-L/usr/local/opt/libarchive/lib -larchive"

svn checkout svn://svn.code.sf.net/p/hfst/code/trunk hfst-code
cd hfst-code/hfst-ospell

[[ ! -e configure ]] || ./autogen.sh
./configure --enable-zhfst
make

cp .libs/libhfstospell.a "$ROOT/libs"

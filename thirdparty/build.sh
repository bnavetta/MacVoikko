#!/bin/sh

ROOT="$PWD"

# set by Xcode, causes conflicts
unset PROJECT

export PKG_CONFIG_PATH="$ROOT/build/lib/pkgconfig"

echo "\n** Building libarchive **\n"

if [[ ! -d libarchive-build ]]; then
	mkdir libarchive-build && cd libarchive-build
	# Disable some things that aren't included in OS X but might have been installed by Homebrew
	cmake -DCMAKE_INSTALL_PREFIX="$ROOT/build" -DENABLE_NETTLE=OFF -DENABLE_LZMA=OFF ../libarchive
	make all install
	cd "$ROOT"
fi

echo "\n** Building TinyXML2 **\n"

if [[ ! -d tinyxml2-build ]]; then
	mkdir tinyxml2-build && cd tinyxml2-build
	cmake -DCMAKE_INSTALL_PREFIX="$ROOT/build" -DCMAKE_MACOSX_RPATH=ON ../tinyxml2
	make all install
	cd "$ROOT"
fi

echo "\n** Building hfst-ospell **\n"

if [[ ! -f hfst-ospell/hfst-ospell ]]; then
	svn checkout svn://svn.code.sf.net/p/hfst/code/trunk/hfst-ospell
	cd hfst-ospell
	[[ -f configure ]] || ./autogen.sh
	./configure --prefix="$ROOT/build" --enable-zhfst --with-tinyxml2 --without-libxmlpp
	make all install
	cd "$ROOT"
	install_name_tool -id @rpath/libhfstospell.dylib build/lib/libhfstospell.4.dylib
	install_name_tool -id @rpath/libhfstospell.dylib build/lib/libhfstospell.dylib
fi

echo "\n** Building libvoikko **\n"

if [[ ! -f build/lib/libvoikko.dylib ]]; then
	cd corevoikko/libvoikko
	[[ -f configure ]] || ./autogen.sh
	# Look in both /usr/local/lib/voikko and /Library/Spelling/voikko for dictionaries
	./configure --enable-hfst --prefix="$ROOT/build" \
	   --with-dictionary-path="/usr/local/lib/voikko:/Library/Spelling/voikko"
	make all install
	cd "$ROOT"
	install_name_tool -id @rpath/libvoikko.dylib build/lib/libvoikko.1.dylib
	install_name_tool -id @rpath/libvoikko.dylib build/lib/libvoikko.dylib
fi

echo "\n** Building suomimalaga **\n"

which malmake 2>&1 > /dev/null
if [[ $? -eq 0 ]]; then
	cd corevoikko/suomimalaga
	make voikko
	make voikko-install DESTDIR="$ROOT/../Dictionaries"
	cd "$ROOT"
else
	echo "Malaga not installed. Using prebuilt dictionaries"
fi

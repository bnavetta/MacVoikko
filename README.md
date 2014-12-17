## MacVoikko

An OS X Spell Server implementation that uses libvoikko with arbitrary
languages.

This is being implemented as a [Google Code-In 2014 task](http://www.google-melange.com/gci/task/view/google/gci2014/4990598620643328)
and is currently a work in progress.

### Building

Once I work out the details of embedding shared libraries with `@rpath`-based
install names in service bundles, all of these dependencies will be included in
the app and as part of the build process.

This requires [libxml++](http://libxmlplusplus.sourceforge.net/) and
[glibmm](https://developer.gnome.org/glibmm/stable/) to be installed. I
recommend [Homebrew](http://brew.sh/) for that purpose.

It also requires a newer version of libarchive than is included with OS X.
Xcode is currently configured to look in the Homebrew installation prefix for
`libarchive`, but that can be changed in the linker flag settings and build
script (see below).

The `build-*` scripts in the `script` directory build (and download, in the case
of hfst) the necessary voikko and hfst libraries and place them in the `libs`
directory, where the Xcode project is configured to expect them. `build-hfst`
must be run first since voikko depends on it.

The project can then be built from Xcode, and the `install` script (which
currently requires xctool) will install the service into `~/Library/Services`
and refresh the service cache.

## MacVoikko

An OS X Spell Server implementation that uses libvoikko with arbitrary
languages.

This is being implemented as a [Google Code-In 2014 task](http://www.google-melange.com/gci/task/view/google/gci2014/4990598620643328)
and is currently a work in progress.

### Building

Dependencies are located under the `thirdparty` directory. Most are Git
submodules, and some are cloned during the build process. To build dependencies, run
`thirdparty/build.sh`. This script is also run during Xcode's build process, but
if execution fails, running outside of Xcode (from the `thirdparty` directory)
may be more successful, or at least provide more helpful error messages.

The project can then be built from Xcode, and the `install` script (which
currently requires xctool) will install the service into `~/Library/Services`
and refresh the service cache.

## MacVoikko

An OS X Spell Server implementation that uses libvoikko with arbitrary
languages.

This is being implemented as a [Google Code-In 2014 task](http://www.google-melange.com/gci/task/view/google/gci2014/4990598620643328)
and is currently a work in progress.

### Building

All required libraries are built automatically to ensure portability. Most are
located as submodules in the `thirdparty` directory, and those that do not use
Git are cloned during the build process. The build script
(`thirdparty/build.sh`) is run from Xcode and builds all libraries in the proper
order.

The project can then be built from Xcode, and the `install` script (which
currently requires xctool) will install the service into `~/Library/Services`
and refresh the service cache.

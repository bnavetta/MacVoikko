#!/bin/sh

xctool -project MacVoikko.xcodeproj -scheme MacVoikko install

cp -r /tmp/MacVoikko.dst/Applications/MacVoikko.service "$HOME/Library/Services"

/System/Library/CoreServices/pbs -update

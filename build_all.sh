#!/bin/sh

set -e

KALI_ARCHES="i386 amd64"
KALI_VERSION="${VERSION:-daily}"

# XXX: Use a git checkout of live-build until we have a good version in wheezy
export LIVE_BUILD=/srv/cdimage.kali.org/live/live-build

cd $(dirname $0)

for KALI_ARCH in $KALI_ARCHES; do
	lb clean --purge >prepare.log 2>&1
	lb config --architecture $KALI_ARCH >>prepare.log 2>&1
	lb build >/dev/null
	if [ ! -e binary.hybrid.iso ]; then
		echo "Build of $KALI_ARCH live image failed" >&2
		echo "Last 50 lines of the log:" >&2
		tail -n 50 binary.log >&2
		exit 1
	fi
	mv binary.hybrid.iso images/kali-$KALI_VERSION-$KALI_ARCH.iso
	mv binary.log images/kali-$KALI_VERSION-$KALI_ARCH.log
done

cd images
sha1sum *.iso >SHA1SUMS


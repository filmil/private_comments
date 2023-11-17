#! /bin/bash

# Builds a release of private_comments.
# Run from the project root.

INTERACTIVE=""
if sh -c ": >/dev/tty" >/dev/null 2>/dev/null; then
	# Only add these if running on actual terminal.
	INTERACTIVE="--interactive --tty"
fi

set -x
set -euo pipefail

BUILD_VERSION="${BUILD_VERSION:-}"

# Building the build environment, since we don't have a good
# spot to place the buildenv container.
./linux/make.buildenv.sh

readonly _script_dir="$(pwd)"

docker run ${INTERACTIVE} \
		-u "$(id -u):$(id -g)" \
		-v "${_script_dir}:/src:rw" \
		private_comments_buildenv \
		/bin/bash -c "cd /src/src && ./build.sh ${BUILD_VERSION}"

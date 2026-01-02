#!/bin/bash

set -e

if [ "${1:0:1}" = '-' ]; then
        export SONAR_SCANNER_OPTS="-Xmx1024m"
	set -- sonar-scanner "$@"
fi

exec "$@"

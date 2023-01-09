#!/bin/bash

cd /workdir

tar czf ${BUILD_COMP_TAG}-${BUILD_COMP_TIMESTAMP}.tar.gz nginx
ls -alh ${BUILD_COMP_TAG}-${BUILD_COMP_TIMESTAMP}.tar.gz

echo "Build Comp OK!"
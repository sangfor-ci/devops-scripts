#!/bin/bash

if [ -z $1 ]; then
   curdir=$(cd $(dirname $0); pwd)
else
   # shellcheck disable=SC2034
   curdir=$1
fi

cd "$curdir"

for x in $(find . -type f -name *\.sh); do sed -i 's/\r//' "$x"; done

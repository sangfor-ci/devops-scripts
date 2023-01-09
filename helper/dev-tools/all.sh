#!/bin/bash

DUMP_PATH=${DUMP_PATH:-/home/dev-tools}

if [ ! -d ${DUMP_PATH} ]; then
    mkdir -p ${DUMP_PATH};
fi

curdir=$(
  cd $(dirname $0)
  pwd
)

cd $curdir

chmod u+x .*sh && sed -i 's/\r//' *.sh

/bin/bash ./get_jdk11_jdk8.sh
/bin/bash ./get_maven_gradw.sh
/bin/bash ./get_nodejs14.sh
NODEJS_VERSION=18.12.0 /bin/bash ./get_nodejs14.sh

/bin/bash ./get_python3.sh
/bin/bash ./get_golang.sh
/bin/bash ./get_codeql.sh



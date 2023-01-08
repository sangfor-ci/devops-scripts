#!/bin/bash
# curl --progress-bar | tee /dev/null


curl  --progress-bar -k -X POST \
  'https://10.11.6.26/nexus/service/rest/v1/components?repository=filestore-v2' \
    -H 'accept: application/json' \
    -H 'Content-Type: multipart/form-data' \
    -u admin:string123.   \
    -F 'raw.directory=tech/gcc'   \
    -F 'raw.asset1=@gcc-deps.zip;type=application/octet-stream'  \
    -F 'raw.asset1.filename=gcc-deps.zip' | tee /dev/null


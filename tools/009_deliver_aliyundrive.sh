#!/bin/bash

ALIYUN_DRIVE_TOKEN=${ALIYUN_DRIVE_TOKEN:-b836324372594d19a05d0fcdaab03584}
WEBDAV_SERVER=${WEB_DAV_SERVER:-http://localhost:58080}
WEBDAV_AUTH=${WEB_DAV_AUTH:"-superman:string123."}

CUR_UNIQ_DIR=/temp/$(date +%Y%m%d)
if [ ! "${REMOTE_STORE_DIR}" ]; then
  REMOTE_STORE_DIR=${CUR_UNIQ_DIR}
fi

function create_aliyundrive_dir(){
   curl -u "${WEBDAV_AUTH}" -T ./t10.tar.gz -k \
    "${WEBDAV_SERVER}"/"${REMOTE_STORE_DIR}" || echo 'DIR '"${REMOTE_STORE_DIR}"' Have Exsit'
}

function upload_file_aliyundrive(){

}
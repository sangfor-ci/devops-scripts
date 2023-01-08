#!/bin/bash

GH_TOKEN=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

# Doesn't work ${$1,,}
COMMAND=$(echo "$1"|tr "[:upper:]" "[:lower:]")


function usage() {
cat << EndOfHelp
    Usage: $0 <func_name> <args> | tee $0.log
    Commands - are case insensitive:
        Using for github files upload to github repository.
    Tips:

EndOfHelp
}

case $COMMAND in
    '-h')
        usage
        exit 0;;
    'issues')
        issues
        exit 0;;
esac

function issues(){
cat << EndOfHelp
### 参考文档:
    * https://api.github.com/
### 常见错误和解决方案
    * 错误:
        * ssl 连接异常
    * 后面再说

EndOfHelp
}


function create_org(){
  repo_name=$1

  curl \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${GH_TOKEN}"\
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/orgs/"${repo_name}"/repos \
  -d '{"name":"Hello-World","description":"This is your first repository","homepage":"https://github.com","private":false,"has_issues":true,"has_projects":true,"has_wiki":true}'

}


function upload_file(){
  # timestamp=$(date +%Y%m%d_%H%m%S)
  timestamp=$(date +%Y%m%d)
  filepath=$1
  gh_token=${GH_TOKEN:-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}
  base64_file="$(cat ${filepath} | base64)"
  user_repo=${GH_USER_REPO:-"ci-repo/helloworld-repo"}
  if [ ! ${GH_REMOTE_ARTIFACTS_DIR} ]; then
      upload_dir=${timestamp}
  else
      upload_dir=${GH_REMOTE_ARTIFACTS_DIR}
  fi
  curl --progress-bar \
    -X PUT \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${gh_token}"\
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "https://api.github.com/repos/${user_repo}/contents/${upload_dir}/"$(basename "$filepath") \
    -d @-  << CURL_DATA
  {"message":":tada:upload file sdk","committer":{"name":"${user_repo%/*}","email":"ci@example.com"},"content":"${base64_file}"}
CURL_DATA

}

function upload_dir(){
  cur_dir=$1
  # shellcheck disable=SC2044
  for x in $(find "${cur_dir}" -type f); do
    upload_file "$x"
  done
}

case "$COMMAND" in
'issues')
    issues;;
'upload_file')
    upload_file $2
    ;;
'upload_dir')
    upload_dir $2
    ;;
*)
    usage;;
esac
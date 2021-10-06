#!/bin/bash

set -o xtrace
function disableTrace {
   set +o xtrace
}
trap disableTrace SIGINT
trap disableTrace ERR


ACTION=$@
echo "$ACTION"
export DO_PAT="$(cat ./personal-access-token-2021)"
export PROJECT_NAME="$(cat ./project_name.txt)"
export MY_SSH_IP="$(cat ./.my_ssh_ip.txt)"
terraform ${ACTION} \
  -var "do_token=${DO_PAT}" \
  -var "pvt_key=$HOME/.ssh/id_rsa" \
  -var "project_name=${PROJECT_NAME}" \
  -var "my_ssh_ip=${MY_SSH_IP}" \

disableTrace


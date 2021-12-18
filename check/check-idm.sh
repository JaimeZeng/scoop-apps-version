#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
# set -euxo pipefail

DATE="$(echo $(TZ=UTC date '+%Y-%m-%d %H:%M:%S'))"
tmpFile="./action.tmp"
user_agent='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36'
aria2c_options='--quiet=true --max-connection-per-server=8 --retry-wait=20 --timeout=20 --check-certificate=false --allow-overwrite=true -U "${user_agent}"'

aria2c ${aria2c_options} 'https://pan.jiemi.workers.dev/?file=/Public/scoop/IDM/sha256sum.txt'
mv -f sha256sum.txt ../IDM

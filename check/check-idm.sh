#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
# set -euxo pipefail

DATE="$(echo $(TZ=UTC date '+%Y-%m-%d %H:%M:%S'))"
tmpFile="./action.tmp"
userAgent='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36'
wget --user-agent="${userAgent}" -qO 'sha256sum.txt' 'https://pan.jiemi.workers.dev/?file=/Public/scoop/IDM/sha256sum.txt'


localVersion="$(cat ../IDM | grep -Po "IDM_v[\d.]+" | grep -Po "[\d.]+")"
latestVersion"$(cat sha256sum.txt | grep -Po "IDM_v[\d.]+" | grep -Po "[\d.]+")"

mv -f sha256sum.txt ../IDM
git commit -am "version: update IDM(${localVersion} -> ${latestVersion})" >/dev/null 2>&1

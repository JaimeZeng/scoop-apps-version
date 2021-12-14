#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
# set -euxo pipefail

cur_dir=$(
    cd "$(dirname "$0")"
    pwd
)
DATE="$(echo $(TZ=UTC date '+%Y-%m-%d %H:%M:%S'))"
check_dir="${cur_dir}/check"
tmpFile="./action.tmp"

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[Info]${Font_color_suffix}"
Error="${Red_font_prefix}[Error]${Font_color_suffix}"
Tip="${Green_font_prefix}[Tip]${Font_color_suffix}"

cd ${check_dir}
echo -e "Check MSEdge..."
bash check-msedge.sh
git commit -am "version: update MSEdge"
git push origin github

cd ${check_dir}
echo -e "Check MouseInc..."
bash check-mouseinc.sh
git commit -am "version: update MouseInc"
git push origin github

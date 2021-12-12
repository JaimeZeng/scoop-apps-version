#!/bin/bash
PATH="/usr/local/bin:/usr/bin:/bin"
set -euxo pipefail

userAgent="Microsoft Edge Update/1.3.139.59;winhttp"
DATE="$(echo $(TZ=UTC date '+%Y-%m-%d %H:%M:%S'))"

function getLatestVersion() {
    local versionUrl="https://www.microsoftedgeinsider.com/api/versions"
    curl -A "$userAgent" "$versionUrl" | jq -r "$1, $2, $3, $4"
    return $?
}

function getGeneratedVersionInfo() {

    archArr=("X64" "X86" "ARM64")
    productArr=("stable" "beta" "dev" "canary")
    versionArr=($(getLatestVersion ".stable" ".beta" ".dev" ".canary"))

    # first run
    rm -f msedge.json
    cp msedge.src.json msedge.json
    sed -e "s|check-time|${DATE}|g" -i msedge.json
    for ((i = 0; i < ${#productArr[@]}; i++)); do
        sed -e "s|msedge-${productArr[i]}-win-ver|${versionArr[i]}|g" -i msedge.json
        for arch in ${archArr[@]}; do
            edgeUrl="https://msedge.api.cdp.microsoft.com/api/v1.1/internal/contents/Browser/namespaces/Default/names/msedge-${productArr[i]}-win-$arch/versions/${versionArr[i]}/files?action=GenerateDownloadInfo&foregroundPriority=true"
            fileName="MicrosoftEdge_${arch}_${versionArr[i]}.exe"
            request=$(curl -k -s -A "${userAgent}" "${edgeUrl}" -X POST -d "{\"targetingAttributes\":{}}" | jq --arg NAME ${fileName} '.[] | select(.FileId==$NAME)' | jq 'del(.Hashes.Sha1, .DeliveryOptimization)')
            echo "${request}"
            releaseInfo=($(echo "$request" | jq '.Hashes = .Hashes.Sha256'))
            releaseInfoFileId=$(echo "$request" | jq -r '.FileId')
            releaseInfoUrl=$(echo "$request" | jq -r '.Url')
            # SHA256 HMAC -> SHA256
            releaseInfoSha256HashesArr=($(echo "$request" | jq -r '.Hashes.Sha256' | base64 -d | xxd -p))
            releaseInfoSha256Hashes=$(echo "${releaseInfoSha256HashesArr[*]}" | sed 's/ //g')
            releaseInfoSizeInBytes=$(echo "$request" | jq -r '.SizeInBytes')

            sed -e "s|msedge-${productArr[i]}-win-${arch}-filename|${releaseInfoFileId}|g" \
                -e "s|msedge-${productArr[i]}-win-${arch}-url|${releaseInfoUrl}|g" \
                -e "s|msedge-${productArr[i]}-win-${arch}-hash|${releaseInfoSha256Hashes}|g" \
                -e "s|msedge-${productArr[i]}-win-${arch}-size|${releaseInfoSizeInBytes}|g" \
                -i \
                msedge.json
        done
    done
}

# sudo apt install curl jq xxd -y
getGeneratedVersionInfo

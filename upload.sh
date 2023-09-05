#!/bin/sh

while getopts ":f:p:t:" opt
do
   case "$opt" in
      f ) localFile="$OPTARG" ;;
      p ) targetPath="$OPTARG" ;;
      t ) apiToken="$OPTARG" ;;
   esac
done

# Print helpFunction in case parameters are empty
if [ $localFile ] && [ $targetPath ] && [ $apiToken ]
then
  sessionId=$(curl -X POST https://content.dropboxapi.com/2/files/upload_session/start \
    --header "Authorization: Bearer ${apiToken}" \
    --header "Dropbox-API-Arg: {\"close\": false}" \
    --header "Content-Type: application/octet-stream" | jq -r '.session_id')
  totalFileSize=$(wc -c ${localFile} | cut -d' ' -f1)
  chunkSize=150000000
  chunkDir="chunks"

  if [ ! -d "${chunkDir}" ]; then
    mkdir ${chunkDir}
  fi

  split -db ${chunkSize} ${localFile} ./${chunkDir}/
  cd ${chunkDir}

  offset=0
  for file in `ls -tU *`
  do
    curl -X POST https://content.dropboxapi.com/2/files/upload_session/append_v2 \
      --header "Authorization: Bearer ${apiToken}" \
      --header "Dropbox-API-Arg: {\"cursor\": {\"session_id\": \"${sessionId}\",\"offset\": ${offset}},\"close\": false}" \
      --header "Content-Type: application/octet-stream" \
      --data-binary @$file

    offset=$((offset+chunkSize))
  done

  curl -X POST https://content.dropboxapi.com/2/files/upload_session/finish \
    --header "Authorization: Bearer ${apiToken}" \
    --header "Dropbox-API-Arg: {\"cursor\": {\"session_id\": \"${sessionId}\",\"offset\": ${totalFileSize}},\"commit\": {\"path\": \"${targetPath}/${localFile}\",\"mode\": \"add\",\"autorename\": true,\"mute\": false,\"strict_conflict\": false}}" \
    --header "Content-Type: application/octet-stream"

  rm -rf ${chunkDir}
fi

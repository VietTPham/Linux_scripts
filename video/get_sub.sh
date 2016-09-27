#!/bin/bash
#by: Viet Pham
#Version: 2016.08.29
#Description: Extract subtitle from a video file

if [ $# -lt 2 ]; then
  echo "How to use: $0 <track number> <list of files>"
fi

#install programs if it is missing
which mkvextract &>/dev/null
if [ $? -eq 1 ]; then
  echo "Installing mkvtoolnix..."
  yum install -y mkvtoolnix &>/dev/null
fi

which ffmpeg &>/dev/null
if [ $? -eq 1 ]; then
  echo "Installing ffmpeg..."
  yum install -y ffmpeg &>/dev/null
fi

for i in "${@:2}"
do 
  out=$(sed 's/...$/srt/'<<<$i)
  mkvextract tracks "$i" $1:"$out"
  #if mkvextract does not wok correctly
  if [ $? -gt 0 ]; then
    ffmpeg -i "$i" -an -vn -c:s:0.$1 srt "$out"
  fi
done

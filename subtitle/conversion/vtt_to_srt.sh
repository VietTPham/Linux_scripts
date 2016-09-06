#!/bin/bash
#by Viet Pham
#Version: 2016.09.16

if [ $# -lt 1 ]; then
  echo "How to use: $0 <list of vtt file(s)>"
  exit 1
fi
for vtt in "${@:1}"; do
  cat $vtt  | sed -e 's/  //g' -e 's/^ //g' | tail -n +3 > $(sed 's/...$/srt/g' <<< $vtt)
  #dos2unix -q $(sed 's/...$/srt/g' <<< $vtt) Need to review if this is needed or not
done

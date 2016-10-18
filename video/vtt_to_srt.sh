#!/bin/bash
#by: Viet Pham
#Version: 2016.09.13
#Description: Convert vtt subtitle to srt
if [ $# -lt 1 ]; then
  echo "How to use: $0 <list of vtt files>"
  exit 1
fi
for vtt in "${@:1}"; do
  #output=$(sed 's/...$/srt/g' <<< $vtt 
  cat $vtt  | sed -e 's/  //g' -e 's/^ //g' | tail -n +3 > $(sed 's/...$/srt/g' <<< $vtt)
  #dos2unix -q $(sed 's/...$/srt/g' <<< $vtt) #this is optional
done

#!/bin/bash

#dependency
#yum install -y curl
#debian/ubuntu
#apt-get install -y uni2ascii coreutils libc-bin sed wget
#downlaod database if it is not up to date
wget -N -q https://3ds.titlekeys.com/json
if [ -f 3dsreleases.xml ]; then
  wget -q -O 3dsreleases.xml http://3dsdb.com/xml.php
fi
#parse json file
json=$(cat json | sed -e 's/^\[//' -e 's/\]$//' -e $'s/},{/}\\\n{/g'|./ascii2uni -a U -q | iconv -f utf-8 -t ascii//TRANSLIT)
#json=$(echo -e "$( cat json| sed -e 's/^\[//' -e 's/\]$//' -e $'s/},{/}\\\n{/g')" )

#parse over file list
for f in "$@"; do
  echo "Renaming $f"
  titleid=$(head --bytes=11300 "$f" | tail --bytes 8 | xxd | awk '{print $2$3$4$5}') 
  if echo $titleid | grep  00040000 &>/dev/null ; then
    type=eShopApp
  elif echo $titleid | grep 00040001 &>/dev/null; then
    type=DlpChild
  elif echo $titleid | grep 00040002 &>/dev/null; then
    type=Demo
  elif echo $titleid | grep 0004000e &>/dev/null; then
    type=Patch
  elif echo $titleid | grep 0004008c &>/dev/null; then
    type=DLC
  elif echo $titleid | grep 00048004 &>/dev/null; then
    type=DSiWare
  elif echo $titleid | grep 0004800[5f] &>/dev/null; then
    type="DSi System"
  fi
  if echo "$json" | grep -i $titleid &>/dev/null ; then
    title=$(echo "$json" | grep -i $titleid | cut -d '"' -f20 | sed 's/[\/:*?<>|]//g')
    region=$(echo "$json" | grep -i $titleid | cut -d '"' -f24)
    titleID=$(echo "$json" | grep -i $titleid | cut -d '"' -f4)
    serial=$(echo "$json" | grep -i $titleid | cut -d '"' -f12)
    mv -n "$f" "$(dirname "$f")/$type - $title ($region) [$titleID - $serial].cia" &>/dev/null
  elif grep -i "$titleid" 3dsreleases.xml &>/dev/null ; then
    title_block=$(grep -i "$titleid" -A 0 -B 7 3dsreleases.xml)
    title=$(echo "$title_block" | grep name | cut -d'>' -f2 | cut -d'<' -f1 | sed 's/[\/:*?<>|]//g')
    region=$(echo "$title_block" | grep region | cut -d'>' -f2 | cut -d'<' -f1)
    serial=$(echo "$title_block" | grep serial | cut -d'>' -f2 | cut -d'<' -f1)
    filename=$(basename "$f")
    mv -n "$f" "$(dirname "$f")/$type - $title ($region) [$titleid - $serial].cia" &>/dev/null

  else
    echo "Cannot find game in 3dsreleases.xml or json.\n Try deleting 3dsreleases.xml and json, and run the program again."
  fi
done

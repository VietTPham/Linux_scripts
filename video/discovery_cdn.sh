#!/bin/bash

curl -o $1.vtt https://fusion.ddmcdn.com/subtitles/$(cut -d'/' -f5-8 <<< $2| sed 's/-,.*//').vtt

curl $(sed 's/index_._av/index_8_av/' <<< $2) -H 'Host: dscusvod-vh.akamaihd.net' -H 'User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:49.0) Gecko/20100101 Firefox/49.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate, br' -H 'Connection: keep-alive' -o index_8_av.m3u8

for link in $(grep https index_8_av.m3u8); do 
  curl $link -H 'Host: dscusvod-vh.akamaihd.net' -H 'User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:49.0) Gecko/20100101 Firefox/49.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate, br' -H 'Connection: keep-alive' -o $(sed -e 's/^.*seg/seg/' -e 's/\?.*//'<<< $link) -ss &
done

sed -e 's/^.*seg/seg/' -e 's/\..*/\.ts/' -i index_8_av.m3u8
ffmpeg -i index_8_av.m3u8 -c copy $1.mp4
#rm -f segment*

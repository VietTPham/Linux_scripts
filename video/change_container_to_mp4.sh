#!/bin/bash

out=$(sed 's/...$/mp4/'<<<$1)
ffmpeg -i "$1" -vcodec copy -acodec copy "$out"

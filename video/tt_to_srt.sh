#!/bin/bash
#By: Viet T Pham
#Version: 2016.10.18
#Description: Using bash to convert tt subtitle to srt subtitle
#Depedency: Debian: libhtml-parser-perl Centos: perl-HTML-Parser 
#Install dependency: apt-get install libhtml-parser-perl; yum install perl-HTML-Parser
#Benchmark: tested on a tt file with 320709 bytes, and 2131 lines
#Benchmark result: ./tt_to_srt.sh subtitle
#real    0m0.116s
#user    0m0.134s
#sys     0m0.007s

if [ $# -lt 1 ]; then
  echo "How to use: $0 <list of tt files>"
  exit 1
fi
for tt in "${@:1}"; do
  grep begin $tt | nl | sed 's/^[ ]*\([0-9]*\).*begin="\(.\{8\}\)\:\(.*\)" end="\(.\{8\}\)\:\([0-9]*\)".*>\(.*\)<\/p>/\1 \n\2,\3 --> \4,\5 \n\6\n /g' | perl -MHTML::Entities -e 'while(<>) {print decode_entities($_);}' > $(sed 's/\..*/.srt/' <<< $tt)
done

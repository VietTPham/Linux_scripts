#!/bin/bash
for i in $(seq 1 99); do
  #if it is not even
  if [[ $(expr $i % 2) != 0 ]]; then
    echo $i
  fi
done

#!/bin/bash
#by: Viet Pham
#Version: 2016.09.15
#Description: Linux bash that read sfo file and display its information

#TODO: Add argument popup
#header information
magic=$(dd bs=1 count=4 status=none if=$1)
version=$(dd bs=1 skip=$((0x04)) count=4 status=none if=$1 | od -A n -t x1 | awk '{print $1"."$2$3$4}')
key_table_start=$(dd bs=1 skip=$((0x08)) count=4 status=none if=$1 | od -A n -t x1 | awk '{print "0x"$4$3$2$1}')
data_table_start=$(dd bs=1 skip=$((0x0C)) count=4 status=none if=$1 | od -A n -t x1 | awk '{print "0x"$4$3$2$1}')
tables_entries=$(echo $((16#$(dd bs=1 skip=$((0x10)) count=4 status=none if=$1 | od -A n -t x1 | awk '{print $4$3$2$1}'))))

output="magic:\t$magic
version:\t$version
key_table_start:\t$key_table_start
data_table_start:\t$data_table_start
tables_entries:\t$tables_entries"
key_table_next=$key_table_start
data_table_next=$data_table_start

#key and data information
for i in $(seq $tables_entries); do

  #key value
  key=$(dd if=$1 bs=1 skip=$(($key_table_next)) status=none| head -n1 | sed 's/\x0.*$//g')

  #increment key value
  key_table_next=$(printf "0x%08x\n" $(($key_table_next + $(echo $key | wc -m))))
  
  #data value
  #length include the null character
  data_len=$(printf "%d\n" $(dd bs=1 skip=$(($(printf "0x%06x8\n" $(($i))))) count=4 status=none if=$1 | od -A n -t x1 | awk '{print "0x"$4$3$2$1}'))
  
  data_offset=$(dd bs=1 skip=$(($(printf "0x%06x0\n" $(($i + 1))))) count=4 status=none if=$1 | od -A n -t x1 | awk '{print "0x"$4$3$2$1}')
  
  #data is calculated using data_table_start + data_offset
  data=$(dd if=$1 bs=1 skip=$(($data_offset + $data_table_start)) count=$((data_len - 1)) status=none )
  if [ $data_len -eq 4 ]; then
	data=$(dd if=$1 bs=1 skip=$(($data_offset + $data_table_start)) count=$((data_len - 1)) status=none | od -A n -t x1 | awk '{print "0x"$3$2$1}')
  fi

  #append key and data to output
  output="$output\n$(printf "%s:\t%s" $key "$data")"
done

#display the ouput in a nice format
printf "$output\n" | column -t -s $'\t'


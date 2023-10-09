#!/bin/bash

shopt -s globstar
f="./generation/*"

#echo $f

filearray=($f)

for FILE in ${filearray[@]}
do


  lnct=$(cat $FILE | wc -l)
  #echo "has $lnct lines"

  c=$(bc -l <<< "scale=4 ; ${RANDOM}/32767")
  z=$(bc -l <<< "scale=4 ; $lnct*$c")
  y=$(printf "%.0f" $z)

  echo "using $y/$lnct lines"
  
  nf=$(echo $FILE | sed 's/generation/completion/')

  echo "$FILE -> $nf"

  #out=$(head -n $y $FILE)

  #cat ./preamble_completion > $nf
  #echo "[CODE_START]" >> $nf
  head -n $y $FILE | sed -e "s/\r//g" > $nf
  #echo "[CODE_END]" >> $nf

  echo

done


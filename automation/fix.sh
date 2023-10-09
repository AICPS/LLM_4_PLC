#!/bin/bash

shopt -s globstar
cp generation/* fixing
f="./fixing/*"

#echo $f

filearray=($f)

for FILE in ${filearray[@]}
do
  echo $FILE

  res="passed compiler validation"

  while [[ $res == *"passed compiler validation"* ]]

  do
    ln=$(wc -l $FILE | awk '{print $1}')

    echo $ln

    sed -i $((RANDOM % $ln))d $FILE

    cd ..
    res=$(./grammar_check.sh dataset/$FILE)
    cd dataset
    
  done


  f=$(cat $FILE)

  #cat ./preamble_fixing > $FILE
  #echo "[CODE_START]" >> $FILE
  echo "$f" | sed -e "s/\r//g" >> $FILE
  #echo "[CODE_END]" >> $FILE

done

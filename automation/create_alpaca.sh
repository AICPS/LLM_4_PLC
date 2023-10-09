#!/bin/bash

#declare -a ds=("completion")
declare -a ds=("completion" "fixing")

for d in "${ds[@]}"
do

  rm -f $d.json

  touch $d.json

  echo "[" >> $d.json

  shopt -s globstar
  f="./$d/*"

  #echo $f

  filearray=($f)

  for FILE in ${filearray[@]}
  do

    echo    "  {" >> $d.json

    echo -n "    \"instruction\":\"" >> $d.json
    q1=$(cat "./preamble_$d")
    echo -n ${q1//$'\n'/\\n} >> $d.json
    echo    "\"," >> $d.json

    echo -n "    \"input\":\"" >> $d.json
    q2=$(cat "$FILE" | sed -e "s/\r$//g" | LANG=C sed 's/[\d128-\d255]//g')
    echo -n ${q2//$'\n'/\\n} >> $d.json
    echo    "\"," >> $d.json


    echo -n "    \"output\":\"" >> $d.json
    f2=$(echo $FILE | sed "s/$d/generation/")
    q3=$(cat "$f2" | sed -e "s/\r$//g" | LANG=C sed 's/[\d128-\d255]//g')
    echo -n ${q3//$'\n'/\\n} >> $d.json
    echo    "\"" >> $d.json

    echo    "  }," >> $d.json

  done


  sed -i '$ d' $d.json
  echo    "  }" >> $d.json


  echo "]" >> $d.json


done

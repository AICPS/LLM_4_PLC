#!/bin/bash

count=0
pass_compile=0

for file in results/codellama34b/good_prompt_lora_syntax/*.ST
do
  echo $file
  

  cd ..
  res=$(./grammar_check.sh "dataset/$file")
  cd dataset

  if [[ $res == *"passed compiler validation"* ]]; then
    let "pass_compile++"
  else
    res=$(echo $res | sed '/^generating/,$ d')
    if [[ "$res" == *"unknown syntax error"* ]] 
    then
      echo $res
      echo
      failed_file+="$(basename $file) "
    fi
  fi

  let "count++"

done

echo
echo
echo "summary:"
echo "  | total files     : $count" 
echo "  | pass compile    : $pass_compile" 
echo
echo "  | list of failures:"
echo "  | $failed_file"
echo

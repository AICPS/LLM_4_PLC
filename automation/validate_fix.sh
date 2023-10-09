#!/bin/bash
shopt -s globstar
f="fixing/*"

#echo $f
count=0
pass_compile=0
pass_lint=0

filearray=($f)

failed_file=""

for FILE in ${filearray[@]}
do
  echo $FILE

  cd ..
  res=$(./grammar_check.sh $FILE)
  cd dataset

  if [[ $res == *"passed compiler validation"* ]]; then
    let "pass_compile++"
  else
    echo "  ^ failed compile"
    failed_file+="$FILE "
    #echo $failed_file
  fi
  if [[ $res == *"passed linter validation"* ]]; then
    let "pass_lint++"
  else
    echo "  ^ failed lint"
  fi

  let "count++"

done

echo
echo
echo "summary:"
echo "  | total files     : $count" 
echo "  | pass compile    : $pass_compile" 
echo "  | pass lint       : $pass_lint"
echo
echo "  | list of failures:"
echo "  | $failed_file"
echo


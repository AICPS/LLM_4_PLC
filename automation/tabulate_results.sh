#!/bin/bash


r_dirs=$(find results/code*/g* -type d)



for r_dir in $r_dirs
do
  echo $r_dir



  compile_pass=0
  compile_err=0
  count=0
  


  for FILE in $r_dir/*.ST
  do
    
    cd ..
    res=$(./grammar_check.sh dataset/$FILE)
    cd dataset
    
    if [[ $res == *"passed compiler validation"* ]]; then
      let "compile_pass++"
    else
      #echo "e"
      #
      # TODO: get compiler error rate
      e_num_raw=$(echo "$res" | grep -e error | wc -l)
      echo "e" > /dev/null
      e_num=$((e_num_raw - 3))

      compile_err=$(($compile_err+$e_num))
    fi

    let "count++"
  done

  echo
  echo
  echo "summary for configuration $r_dir"
  echo "  | total files     : $count" 
  echo "  | pass compile    : $compile_pass" 
  echo "  | # of errors     : $compile_err"

done

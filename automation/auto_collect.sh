#!/bin/zsh


out_dir="results/codellama7b/good_prompt"
prompt_sh="./gen_prompt_good.sh"

echo
echo "the output directory will be $out_dir"
echo "the prompt generation script used will be $prompt_sh"
echo
read -q "e?is this ok? make sure it is, or else existing files will be overwritten! (y/n) "
echo
if [[ $e =~ ^[Yy]$ ]]
then
  echo
  echo "the order of files is as follows:"
  echo

  for entry in "completion"/*
  do
    echo "$entry"
  done

  echo

  LC_ALL=en_US.UTF-8
  LANG=en_US.UTF-8

  echo "you need to omit the \"completion/\""
  read "e?pick a file (i.e. position) to continue from: "
  #echo "$e"

  if [[ ! -f "completion/$e" ]]
  then
    echo "please pick a real file"
    exit 1
  fi

  echo
  echo "the list of to-be-processed files is as follows:"
  echo


  for entry in "completion"/*
  do
    if [[ "$entry" > "completion/$e" || "$entry" == "completion/$e" ]]
    then
      echo $entry
    fi
  done

  for entry in "completion"/*
  do
    if [[ "$entry" > "completion/$e" || "$entry" == "completion/$e" ]]
    then

      echo
      read -q "q?process file $entry? (y/n) "
      echo
      if [[ $q =~ ^[Yy]$ ]]
      then

        echo "ok, using $entry"

        $prompt_sh $entry > /dev/null

        echo "copied prompt to clipboard"
        echo "run it through the LLM now!"

        entry_trunc=${entry::-3}

        echo "a vim instance of $entry_trunc""_RESULT.ST in $out_dir is being created so you can dump the output in it"
        read -q "a?press any key when you're done running it through the LLM"

        entry_path=${entry_trunc:11}

        echo "$out_dir/$entry_path""_RESULT.ST" > "$out_dir/$entry_path""_RESULT.ST"
        echo "REPLACE THESE CONTENTS WITHOUT THE OUTPUT OF THE LLM" >> "$out_dir/$entry_path""_RESULT.ST"
        
        vim "$out_dir/$entry_path""_RESULT.ST"

        echo
        echo "finished result entry for $entry, moving on"


        echo
      else
        continue
      fi

    fi
  done


else
  exit 1
fi

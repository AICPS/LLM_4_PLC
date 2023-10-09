#!/bin/zsh

#
#
# NOTE: this is for good_prompt_lora_syntax ONLY
#
#


out_dir="results/codellama34b/good_prompt_lora_syntax"
prompt_sh="./gen_prompt_good_syntax.sh"

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
        
        entry_trunc=${entry::-3}
        entry_path=${entry_trunc:11}

        f_list=(_ARRAY_MUL_RESULT.ST CYCLE_TIME_RESULT.ST DEG_TO_DIR_RESULT.ST D_TRUNC_RESULT.ST DWORD_TO_DT_RESULT.ST FILTER_W_RESULT.ST JD2000_RESULT.ST MB_SERVER_RESULT.ST PARSET2_RESULT.ST PARSET_RESULT.ST REPLACE_CHARS_RESULT.ST RMP_B_RESULT.ST RTC_MS_RESULT.ST SET_DT_RESULT.ST SETUP_LOCATION_RESULT.ST SH_2_RESULT.ST TEMP_NI_RESULT.ST TREND_DW_RESULT.ST)

        f_list2=(_ARRAY_MUL_RESULT.ST CYCLE_TIME_RESULT.ST DEG_TO_DIR_RESULT.ST D_TRUNC_RESULT.ST)


        cp "results/codellama34b/good_prompt_lora/"${entry_path}"_RESULT.ST" results/codellama34b/good_prompt_lora_syntax/
        
        f_new=$(basename "$out_dir/$entry_path")
        if [[ ${f_list[@]} =~ $f_new ]]
        then
          echo "processing file: does not compile"
          if [[ ${f_list2[@]} =~ $f_new ]]
          then
            echo "processing file: this file has unknown syntax error, skipping"
            continue
          fi
        else
          #echo "value not found"
          # now we can just copy it and move on
          echo "skipping file: already compiles"
          continue
        fi

        g_path="dataset/"${out_dir}"/"${entry_path}"_RESULT.ST"
        g_path2=${out_dir}"/"${entry_path}"_RESULT.ST"
        #echo "the edited path is: $g_path"
        cd ..
        g_test=$(./grammar_check.sh "$g_path")
        cd dataset

        while [[ "$g_test" != *"passed compiler validation"* ]]
        do

          read -q "a?stop here or continue using grammar_check.sh? (y/n) "
          echo

          if [[ $a =~ ^[Yy]$ ]]
          then


            cd ..
            ./grammar_check.sh "$g_path" > dataset/e
            cd dataset

            $prompt_sh $entry > /dev/null

            entry="../$g_path"
            echo $entry

            echo "copied prompt to clipboard"
            echo "run it through the LLM now!"


            echo "a vim instance of $entry_trunc""_RESULT.ST in $out_dir is being created so you can dump the output in it"
            read -q "a?press any key when you're done running it through the LLM"
            echo

            echo "$out_dir/$entry_path""_RESULT.ST" >> "$out_dir/$entry_path""_RESULT.ST"
            echo "REPLACE THESE CONTENTS WITHOUT THE OUTPUT OF THE LLM" >> "$out_dir/$entry_path""_RESULT.ST"
             
            #echo "$g_path2"
            vim $g_path2

            echo
            echo "now we will rerun this process with the new ST code file"
            echo

            cd ..
            g_test=$(./grammar_check.sh "$g_path")
            cd dataset
          else
            break
          fi
        done
       


        cd ..
        
        ./grammar_check.sh "$g_path" > dataset/e

        cd dataset

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

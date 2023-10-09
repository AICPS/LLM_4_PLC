#!/bin/bash



if [[ $# -ne 1 ]]
then
  echo "need 1 argument (input file) to generate prompt"
  exit 1
fi


p_type="none"

if [[ "$1" == *"fixing"* ]]; then
  p_type="preamble_fixing_with_syntax"
elif [[ "$1" == *"completion"* ]]; then
  p_type="preamble_completion_with_syntax"
else
  echo "only accepting completion or fixing prompts"
  exit 1
fi


if [[ ! -f $1 ]]
then
  echo "file $1 doesn't exist"
  exit 1
fi

e="### Instruction:"
f=$(cat <$p_type)
g="### Input:"
h=$(cat <$1)



printf "$e\n\n$f\n\n$g\n\n$h\n"

printf "$e\n\n$f\n\n$g\n\n$h\n" | xclip -sel clip


#!/bin/bash



if [[ $# -ne 1 ]]
then
  echo "need 1 argument (input file) to generate prompt"
  exit 1
fi


p_type="preamble_completion_with_syntax_check"


if [[ ! -f $1 ]]
then
  echo "file $1 doesn't exist"
  exit 1
fi

e="### Instruction:"
f=$(cat <$p_type)
g="### Input:"
h=$(cat <$1)
i=$(sed '0,/^generating /d' e)


#printf "$e\n\n$f\n\n$g\n\n$h\n$i"

printf "$e\n\n$f\n\n$g\n\n$h\n$i" | xclip -sel clip


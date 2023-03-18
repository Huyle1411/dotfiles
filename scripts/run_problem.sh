#!/bin/bash

# to color the output text in different colours
green=$(tput setaf 71);
red=$(tput setaf 1);
blue=$(tput setaf 32);
orange=$(tput setaf 178);
bold=$(tput bold);
reset=$(tput sgr0);

dist=$(( ($(tput cols) - 2)/3 ))
CUSTOMTAB=''
for ((i=1; i<=$dist; i++))
do
  CUSTOMTAB+=' '
done

# target/ {target.cpp sample.in sample.out}
# get target folder
target=$1
if [ -d "$target" ]; then
  cd $target
fi
build_dir="build"
LANG="cpp"

# detect language by file extension
if [[ -f "${target}.java" ]]; then
  echo "detect java lang"
  LANG="java"
elif [[ -f "${target}.cpp" ]]; then
  echo "detect cpp lang"
  LANG="cpp"
elif [[ -f "${target}.py" ]]; then
  echo "detect python lang"
  LANG="python"
else
  echo "cannot detect lang. Exit"
  exit 0
fi

# if [ $# -eq 1 ]
#   then
#     LANG="cpp" #default
#   else
#     LANG=$2
# fi

if [ "$LANG" == "cpp" ]; then
  execute_file="build/${target}"
elif [ "$LANG" == "java" ]; then
  execute_file="${target}/${target}"
elif [ "$LANG" == "python" ]; then
  execute_file="${target}.py"
fi

right_answer=0
test_case=1

# check whether exists sample test cases
count=`ls -1 *.in 2>/dev/null | wc -l`
if [ $count == 0 ]
then 
  echo "${orange}No test cases found!!!${reset}"
  cd ..
  exit 0
fi

for input_file in "${target}_"*.in
do
  filename=$(basename -- "$input_file")
  filename="${filename%.*}"
  output_file="${filename}.res"
  expected_file="${filename}.out"
  
  # run
  if [ "$LANG" == "cpp" ]; then
    ./$execute_file < $input_file > $output_file
  elif [ "$LANG" == "java" ]; then
    java -cp $build_dir $execute_file < $input_file > $output_file
  elif [ "$LANG" == "python" ]; then
    pypy3 -W ignore $execute_file < $input_file > $output_file
  fi

  # compare output
  # if diff -w -B -F --label --side-by-side $expected_file $output_file > dont_show_on_terminal.txt; then
  if diff -Z -B <(grep -vE '^\s*$' $expected_file) <(grep -vE '^\s*$' $output_file) > dont_show_on_terminal.txt; then
    echo "Test case $test_case: ${bold}${green}Accepted${reset}"
    right_answer=$((right_answer+1))
    rm $output_file
  else
    echo "Test case $test_case: ${bold}${red}Wrong Answer${reset}"
    echo "${blue}Input: ${reset}"
    cat $input_file
    echo ""

    echo "${blue}Output: ${reset}${CUSTOMTAB}${blue}Expected: ${reset}"
    colordiff -y -Z -B <(grep -vE '^\s*$' $output_file) <(grep -vE '^\s*$' $expected_file)
  fi
		# cat $output_file
		# echo ""
		#
  #   echo "${blue}Expected: ${reset}"
		# cat $expected_file
		# echo ""
	test_case=$((test_case+1))
done

echo "Testing complete!"
echo "${bold}${green}${right_answer}${reset} test cases passed"

rm dont_show_on_terminal.txt
cd ..

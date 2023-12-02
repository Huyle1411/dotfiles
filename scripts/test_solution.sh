#!/bin/bash

# to color the output text in different colours
green=$(tput setaf 71)
red=$(tput setaf 1)
blue=$(tput setaf 32)
orange=$(tput setaf 178)
bold=$(tput bold)
reset=$(tput sgr0)

TIMEOUT_STATUS=124

# target/ {target.cpp sample.in sample.out}
# get target folder
PROGRAM_LANG=$1
target=$2
target=$(basename -- "$target")
target="${target%.*}"
# if [ -d "$target" ]; then
# 	cd $target
# fi
# build_dir="build"

# detect language by file extension
# if [[ -f "${target}.java" ]]; then
#   echo "detect java lang"
#   LANG="java"
# elif [[ -f "${target}.cpp" ]]; then
#   echo "detect cpp lang"
#   LANG="cpp"
# elif [[ -f "${target}.py" ]]; then
#   echo "detect python lang"
#   LANG="python"
# else
#   echo "cannot detect lang. Exit"
#   exit 0
# fi

# Compile first, default with DEBUG mode
if [ "$PROGRAM_LANG" == "cpp" ]; then
	bash ~/scripts/build.sh "$target" 2
	if [ $? -eq 1 ]; then
		exit 1
	fi
fi

if [ "$PROGRAM_LANG" == "cpp" ]; then
	execute_file="${target}"
elif [ "$PROGRAM_LANG" == "java" ]; then
	execute_file="${target}/${target}"
elif [ "$PROGRAM_LANG" == "python" ]; then
	execute_file="${target}.py"
fi

right_answer=0
test_case=1

# check whether exists sample test cases
count=$(ls -1 *.in 2>/dev/null | wc -l)
if [ $count == 0 ]; then
	echo "${orange}No test cases found!!!${reset}"
	cd ..
	exit 0
fi

execute_solution() {
	if [ "$PROGRAM_LANG" == "cpp" ]; then
		timeout 5 ./$execute_file <$input_file >$output_file
	elif [ "$PROGRAM_LANG" == "java" ]; then
		timeout 5 java -cp $build_dir $execute_file <$input_file >$output_file
	elif [ "$PROGRAM_LANG" == "python" ]; then
		timeout 5 python3 -W ignore $execute_file <$input_file >$output_file
	fi
}

for input_file in "${target}_"*.in; do
	filename=$(basename -- "$input_file")
	filename="${filename%.*}"
	output_file="${filename}.res"
	expected_file="${filename}.out"

	execute_solution
	result=$?

	if [ "$result" -eq "$TIMEOUT_STATUS" ]; then
		echo "Test case $test_case: ${bold}${orange}Time Limit Exceeded${reset}"
	elif [ "$result" -eq 0 ]; then
		# compare output
		# if diff -w -B -F --label --side-by-side $expected_file $output_file > dont_show_on_terminal.txt; then
		diff_output=$(diff -Z -B <(grep -vE '^\s*$' $output_file) <(grep -vE '^\s*$' $expected_file))
		if [ -n "$diff_output" ]; then
			echo "Test case $test_case: ${bold}${red}Wrong Answer${reset}"
			echo "${blue}Input: ${reset}"
			cat $input_file

			echo "${blue}Output: ${reset}"
			cat $output_file

			echo "${blue}Expected: ${reset}"
			cat $expected_file

			echo "-----------"
			echo $diff_output
		else
			echo "Test case $test_case: ${bold}${green}Accepted${reset}"
			right_answer=$((right_answer + 1))
			rm $output_file
			# colordiff -y -Z -B <(grep -vE '^\s*$' $output_file) <(grep -vE '^\s*$' $expected_file)
		fi
	else
		echo "${red}Error returned: $result${reset}"
	fi
	test_case=$((test_case + 1))
done

echo "Testing complete!"
echo "${bold}${green}${right_answer}${reset} test cases passed"

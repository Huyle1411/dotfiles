#!/bin/bash

# to color the output text in different colours
green=$(tput setaf 71)
red=$(tput setaf 1)
blue=$(tput setaf 32)
orange=$(tput setaf 178)
bold=$(tput bold)
reset=$(tput sgr0)

fullname=$1
target=$(basename -- "$1")
extension="${target##*.}"
target="${target%.*}"
if [[ $extension == "cc" || $extension == "cpp" ]]; then
	extension="cpp"
fi

# target/ {target.cpp sample.in sample.out}
# get target folder
# if [ -d "$target" ]; then
# 	cd $target
# fi
# build_dir="build"

# Compile first, default with DEBUG mode
if [ "$extension" == "cpp" ]; then
	bash ~/scripts/build.sh "$fullname" 2
	if [ $? -eq 1 ]; then
		exit 1
	fi
fi

if [ "$extension" == "cpp" ]; then
	execute_file="${target}"
elif [ "$extension" == "java" ]; then
	execute_file="${target}.java"
elif [ "$extension" == "py" ]; then
	execute_file="${target}.py"
fi

right_answer=0
test_case=1

# check whether exists sample test cases
count=$(ls -1 test/*.in 2>/dev/null | wc -l)
if [ $count == 0 ]; then
	echo "${orange}No test cases found!!!${reset}"
	cd ..
	exit 0
fi

execute_solution() {
	if [ "$extension" == "cpp" ]; then
		/usr/bin/time -v -f "%E" ./$execute_file <$input_file >$output_file 2>$error_file
	# elif [ "$extension" == "java" ]; then
	# 	timeout 5 java -cp $build_dir $execute_file <$input_file >$output_file
	elif [ "$extension" == "py" ]; then
		/usr/bin/time -v python3 -W ignore $execute_file <$input_file >$output_file 2>$error_file
	fi
}

execute_time=""
memory=""

extract_time_memory() {
	execute_time=$(grep -E "User time" $error_file)
	execute_time=$(echo $execute_time | grep -o [0-9]*[.][0-9]*)
	memory=$(grep -E "Maximum resident set size" $error_file)
	memory=$(echo $memory | grep -o [0-9]*)
}

for input_file in "test/sample-*.in"; do
	# filename=$(basename -- "$input_file")
	filename="${input_file%.*}"
	output_file="${filename}.res"
	expected_file="${filename}.out"
	error_file="${filename}.err"

	execute_solution
	result=$?
	extract_time_memory

	# remove output of time -v command
	head -n -23 $error_file >temp.txt && mv temp.txt $error_file

	if [ -s $error_file ]; then
		echo "${reset}${green}Error:${reset}"
		cat $error_file
	fi

	# if [ "$result" -eq "$TIMEOUT_STATUS" ]; then
	# 	echo "Test case $test_case: ${bold}${orange}Time Limit Exceeded${reset}"
	if [ "$result" -eq 0 ]; then
		# compare output
		# if diff -w -B -F --label --side-by-side $expected_file $output_file > dont_show_on_terminal.txt; then
		diff_output=$(diff -Z -B <(grep -vE '^\s*$' $output_file) <(grep -vE '^\s*$' $expected_file))
		if [ -n "$diff_output" ]; then
			echo "Test case $test_case: ${bold}${red}Wrong Answer${reset} ... ${execute_time}s ${memory}KB"
			echo "${reset}${green}Input: ${reset}"
			cat $input_file

			echo "${reset}${green}Output: ${reset}"
			cat $output_file

			echo "${reset}${green}Expected: ${reset}"
			cat $expected_file

			echo "-----------"
			echo $diff_output
		else
			echo "${reset}Test case $test_case: ${bold}${green}Accepted${reset} ... ${execute_time}s ${memory}KB"
			right_answer=$((right_answer + 1))
			# colordiff -y -Z -B <(grep -vE '^\s*$' $output_file) <(grep -vE '^\s*$' $expected_file)
		fi
	else
		echo "${reset}${green}Input: ${reset}"
		cat $input_file
		echo "${red}Error returned: $result${reset}"
	fi
	test_case=$((test_case + 1))
	rm $output_file
	rm $error_file
done

echo "${reset}Testing complete!"
echo "${bold}${green}${right_answer}${reset} test cases passed"

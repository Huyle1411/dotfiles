#!/bin/bash

# to color the output text in different colours
bold=$(tput bold)
red="\e[1;31m"
green="\e[1;32m"
purple="\e[1;35m"
cyan="\e[1;36m"
reset="\e[0m"

fullname=$1
parent_dir="$(dirname "$fullname")"
extension="${fullname##*.}"
target="${fullname%.*}"
echo "${fullname} ${target}"
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
    if [ -f "CMakeLists.txt" ]; then
        target=$(basename -- "$target")
        cd build && make "$target" && cd .. || exit 1
        target="build/${target}"
    else
        bash ~/scripts/build.sh "$fullname" 2 || exit 1
    fi
fi

if [ "$extension" == "cpp" ]; then
    execute_file="${target}"
else
    execute_file="${fullname}"
fi

right_answer=0
test_case=1

# check whether exists sample test cases
count=$(find "${parent_dir}/test" -maxdepth 1 -name "*.in" -type f 2>/dev/null | wc -l)
# count=$(ls -1 test/*.in 2>/dev/null | wc -l)
if [ "$count" == 0 ]; then
    echo -e "${purple}No test cases found!!!${reset}"
    cd ..
    exit 0
fi

execute_solution() {
    if [ "$extension" == "cpp" ]; then
        /usr/bin/time -v -f "%E" ./"$execute_file" <"$input_file" >"$output_file" 2>"$error_file"
    # elif [ "$extension" == "java" ]; then
    # 	timeout 5 java -cp $build_dir $execute_file <$input_file >$output_file
    elif [ "$extension" == "py" ]; then
        /usr/bin/time -v python3 -W ignore "$execute_file" <"$input_file" >"$output_file" 2>"$error_file"
    fi
}

execute_time=""
memory=""

extract_time_memory() {
    execute_time=$(grep -E "User time" "$error_file")
    execute_time=$(echo "$execute_time" | grep -o "[0-9]*[.][0-9]*")
    memory=$(grep -E "Maximum resident set size" "$error_file")
    memory=$(echo "$memory" | grep -o "[0-9]*")
}

for input_file in "$parent_dir"/test/sample-*.in; do
    # filename=$(basename -- "$input_file")
    filename="${input_file%.*}"
    output_file="${filename}.res"
    expected_file="${filename}.out"
    error_file="${filename}.err"

    execute_solution
    result=$?
    extract_time_memory

    # remove output of time -v command
    head -n -23 "$error_file" >temp.txt && mv temp.txt "$error_file"

    if [ -s "$error_file" ]; then
        echo -e "${green}Error:${reset}"
        cat "$error_file"
    fi

    # if [ "$result" -eq "$TIMEOUT_STATUS" ]; then
    # 	echo "Test case $test_case: ${bold}${orange}Time Limit Exceeded${reset}"
    if [ "$result" -eq 0 ]; then
        # compare output
        # if diff -w -B -F --label --side-by-side $expected_file $output_file > dont_show_on_terminal.txt; then
        diff_output=$(diff -Z -B <(grep -vE '^\s*$' "$output_file") <(grep -vE '^\s*$' "$expected_file"))
        if [ -n "$diff_output" ]; then
            echo -e "Test case $test_case: ${bold}${red}Wrong Answer${reset} ... ${execute_time}s ${memory}KB"
            echo -e "${cyan}Input: ${reset}"
            cat "$input_file"

            echo -e "${reset}${cyan}Output: ${reset}"
            cat "$output_file"

            echo -e "${reset}${cyan}Expected: ${reset}"
            cat "$expected_file"

            echo "-----------"
            echo "$diff_output"
        else
            echo -e "${reset}Test case $test_case: ${bold}${green}Accepted${reset} ... ${execute_time}s ${memory}KB"
            right_answer=$((right_answer + 1))
            # colordiff -y -Z -B <(grep -vE '^\s*$' $output_file) <(grep -vE '^\s*$' $expected_file)
        fi
        rm "$output_file"
        rm "$error_file"
    else
        echo -e "${reset}${green}Input: ${reset}"
        cat "$input_file"
        echo -e "${red}Error returned: $result${reset}"
    fi
    test_case=$((test_case + 1))
done

echo -e "${reset}Testing complete!${reset}"
echo -e "${bold}${green}${right_answer}${reset} test cases passed"

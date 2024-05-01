#!/bin/bash

# to color the output text in different colours
green=$(tput setaf 71)
red=$(tput setaf 1)
blue=$(tput setaf 32)
orange=$(tput setaf 178)
bold=$(tput bold)
reset=$(tput sgr0)

target=$1
filename=$(basename -- "$target")
extension="${filename##*.}"
filename="${filename%.*}"
output_file="output.txt"
error_file="error.txt"

opt="$2"

if [[ "$extension" == "cc" || "$extension" == "cpp" ]]; then
	extension="cpp"
fi

if [ -z "$opt" ]; then
	opt=0
fi

if [ "$extension" = "cpp" ]; then
	bash ~/scripts/build.sh "$target" "$opt"

	if [ $? -eq 1 ]; then
		exit 1
	fi
fi

echo "${reset}${green}Input:${reset}"

if [ "$extension" = "cpp" ]; then
	/usr/bin/time -v ./${filename} >$output_file 2>$error_file
elif [ "$extension" = "py" ]; then
	/usr/bin/time -v python3 -W default ${target} >$output_file 2>$error_file
else
	echo "default ....."
	echo $extension
fi

execute_time=""
memory=""

extract_time_memory() {
	execute_time=$(grep -E "User time" $error_file)
	execute_time=$(echo $execute_time | grep -o [0-9]*[.][0-9]*)
	memory=$(grep -E "Maximum resident set size" $error_file)
	memory=$(echo $memory | grep -o [0-9]*)
}

extract_time_memory
# remove output of time -v command
head -n -23 error.txt >temp.txt && mv temp.txt $error_file
echo "${reset}${green}Debug:${reset}"
cat $error_file

echo "${reset}${green}Output:${reset}"
cat $output_file

echo
echo "Time: ${execute_time}s Memory: ${memory}KB"
rm $output_file
rm $error_file

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

if [ "$extension" = "cpp" ]; then
	echo "${green}Input:${reset}"
	(/usr/bin/time -v ./${filename} >output) &>time_info.txt
	echo "${green}Output:${reset}"
elif [ "$extension" = "py" ]; then
	echo "${green}Input:${reset}"
	(/usr/bin/time -v python3 -W default ${target} >output) &>time_info.txt
	echo "${green}Output:${reset}"
else
	echo "default ....."
	echo $extension
fi

execute_time=""
memory=""

extract_time_memory() {
	execute_time=$(grep -E "User time" time_info.txt)
	execute_time=$(echo $execute_time | grep -o [0-9]*[.][0-9]*)
	memory=$(grep -E "Maximum resident set size" time_info.txt)
	memory=$(echo $memory | grep -o [0-9]*)
}

cat output
extract_time_memory
echo
echo "Time: ${execute_time}s Mem: ${memory}KB"
rm output
rm time_info.txt

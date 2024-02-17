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
elif [[ $extension == "py" ]]; then
	extension="python"
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
	./${filename} >output

	echo "${green}Output:${reset}"
elif [ "$extension" = "python" ]; then
	echo "${green}Input:${reset}"
	python3 -W default ${target} >output
	echo "${green}Output:${reset}"
else
	echo "default ....."
	echo $extension
fi

cat output
rm output

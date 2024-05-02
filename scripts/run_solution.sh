#!/bin/bash

# to color the output text in different colours
cyan="\e[1;36m"
reset="\e[0m"

fullname=$1
extension="${fullname##*.}"
filename="${fullname%.*}"
output_file="${filename}.res"
error_file="${filename}.err"

opt="$2"

if [[ "$extension" == "cc" || "$extension" == "cpp" ]]; then
	extension="cpp"
fi

if [ -z "$opt" ]; then
	opt=0
fi

if [ "$extension" = "cpp" ]; then
	bash ~/scripts/build.sh "$fullname" "$opt"

	if [ $? -eq 1 ]; then
		exit 1
	fi
fi

echo -e "${cyan}Input:${reset}"

if [ "$extension" = "cpp" ]; then
	/usr/bin/time -v ./"${filename}" >"$output_file" 2>"$error_file"
elif [ "$extension" = "py" ]; then
	/usr/bin/time -v python3 -W default "${filename}" >"$output_file" 2>"$error_file"
else
	echo "default ....."
	echo $extension
fi

execute_time=""
memory=""

extract_time_memory() {
	execute_time=$(grep -E "User time" "$error_file")
	execute_time=$(echo "$execute_time" | grep -o "[0-9]*[.][0-9]*")
	memory=$(grep -E "Maximum resident set size" "$error_file")
	memory=$(echo "$memory" | grep -o "[0-9]*")
}

extract_time_memory
# remove output of time -v command
head -n -23 "$error_file" >temp.txt && mv temp.txt "$error_file"
echo -e "${cyan}Debug:${reset}"
cat "$error_file"

echo -e "${cyan}Output:${reset}"
cat "$output_file"

echo
echo "Time: ${execute_time}s Memory: ${memory}KB"
rm "$output_file"
rm "$error_file"

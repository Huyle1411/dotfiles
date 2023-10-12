# to color the output text in different colours
green=$(tput setaf 71)
red=$(tput setaf 1)
blue=$(tput setaf 32)
orange=$(tput setaf 178)
bold=$(tput bold)
reset=$(tput sgr0)

type="cpp"
target=$1
extension="$2"
opt="$3"

if [ -z "$opt" ]; then
	opt=0
fi

echo $opt

bash ~/scripts/build_script_cpp.sh "$target" "$opt"

if [ "$extension" = "cpp" ]; then
	echo "${green}Input:${reset}"
	# ./${target} >output
	time ./$target >output
	MEMORY_KB=$(ps -p $$ -o rss=)
	MEMORY_MB=$(awk "BEGIN {printf \"%.2f\", $MEMORY_KB / 1024.0}")
	echo "Memory: $MEMORY_MB MB"
	echo "${green}Output:${reset}"
elif [ "$extension" = "python" ]; then
	echo $target
	echo "${green}Input:${reset}"
	python3 -W default ${target}.py >output
	echo "${green}Output:${reset}"
else
	echo "default ....."
	echo $extension
fi

cat output
rm output

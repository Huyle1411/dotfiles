# to color the output text in different colours
green=$(tput setaf 71)
red=$(tput setaf 1)
blue=$(tput setaf 32)
orange=$(tput setaf 178)
bold=$(tput bold)
reset=$(tput sgr0)

type="cpp"
target=$1
type="$2"

if [ "$type" = "cpp" ]; then
	echo "${green}Input:${reset}"
	./${target} >output
	echo "${green}Output:${reset}"
elif [ "$type" = "python" ]; then
	echo $target
	echo "${green}Input:${reset}"
	python3 -W default ${target}.py >output
	echo "${green}Output:${reset}"
else
	echo "default ....."
	echo $type
fi

cat output
rm output

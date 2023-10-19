# to color the output text in different colours
green=$(tput setaf 71)
red=$(tput setaf 1)
blue=$(tput setaf 32)
orange=$(tput setaf 178)
bold=$(tput bold)
reset=$(tput sgr0)

type="cpp"
extension=$1
opt="$2"
target="$3"

if [ -z "$opt" ]; then
	opt=0
fi

bash ~/scripts/build.sh "$target" "$opt"

if [ "$extension" = "cpp" ]; then
	echo "${green}Input:${reset}"
	./${target} >output

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

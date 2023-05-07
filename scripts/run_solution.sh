# to color the output text in different colours
green=$(tput setaf 71)
red=$(tput setaf 1)
blue=$(tput setaf 32)
orange=$(tput setaf 178)
bold=$(tput bold)
reset=$(tput sgr0)

target=$1

echo "${green}Input:${reset}"
./${target} >output
echo "${green}Output:${reset}"
cat output
rm output

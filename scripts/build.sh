#!/bin/bash

# color
red="\e[1;31m"
green="\e[1;32m"
reset="\e[0m"

filename="$1"
extension="${filename##*.}"
if [ -z "$extension" ]; then
	extension="cc" #default extension
fi
filename="${filename%.*}"

COMMAND="g++"
CXX_LANG_OPTION="-std=c++2a"
CXX_FLAGS="-O0 -Wall -Wextra -Wno-unused-result -Wno-char-subscripts -Wshadow -Wfloat-equal -Wconversion -Wformat-signedness -Wvla -Wduplicated-cond -Wlogical-op -Wredundant-decls -Winvalid-pch"
DEBUG_CXX_FLAGS="-ggdb3 -D_GLIBCXX_DEBUG -D_GLIBCXX_DEBUG_PEDANTIC -D_FORTIFY_SOURCE=2 -fsanitize=undefined,address,float-divide-by-zero,float-cast-overflow -fno-omit-frame-pointer -fno-optimize-sibling-calls -fstack-protector-all -fno-sanitize-recover=all"
DEBUG_LOCAL_CXX_FLAGS="-DDEBUG -I/home/huyle/.template/"

# Check version C++
if echo "$CXX_LANG_OPTION" | grep -q "c++2a"; then
	echo "Compile with C++20 (stdc++2a)."
elif echo "$CXX_LANG_OPTION" | grep -q "c++17"; then
	echo "Compile with C++17 (stdc++17)."
elif echo "$CXX_LANG_OPTION" | grep -q "c++14"; then
	echo "Compile with C++14 (stdc++14)."
else
	echo "Not use C++14 or later."
fi

FINAL_COMMAND="$COMMAND $CXX_LANG_OPTION $CXX_FLAGS"

# 1: Build with DEBUG_CXX_FLAGS
# 2: Build with DEBUG_CXX_FLAGS + DEBUG_LOCAL_CXX_FLAGS
# Others: default build with warning flags only (No debug flags)
if [[ $2 -eq 1 ]]; then
	FINAL_COMMAND+=" $DEBUG_CXX_FLAGS"
	echo "[DEBUG MODE]"
elif [[ $2 -eq 2 ]]; then
	FINAL_COMMAND+=" $DEBUG_CXX_FLAGS $DEBUG_LOCAL_CXX_FLAGS"
	echo "[DEBUG LOCAL MODE]"
else
	echo "[NORMAL MODE]"
fi

if $FINAL_COMMAND -o "$filename" "$filename"."$extension"; then
	echo -e "${green}Compilation Successful $reset"
else
	echo -e "${red}Compilation Failed $reset"
	exit 1
fi

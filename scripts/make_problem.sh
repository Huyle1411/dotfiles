#!/usr/bin/env bash
RED='\033[0;31m'
GREEN='\033[0;32m'

NC='\033[0m' # No Color
TEMPLATE_DIR='/home/huyle/.template'

filepath=$1
PROBLEM_NAME=$(basename "$filepath")
LANG=$2

if [ -z "$LANG" ]; then
	LANG="cpp" #default
fi

# mkdir -p "$filepath"

if [ "$LANG" == "cpp" ]; then
	# Copy files
	cp -r "$TEMPLATE_DIR/template.cpp" "./"
	cp template.cpp "$PROBLEM_NAME".cpp
	printf "${GREEN}created $PROBLEM_NAME.cpp file\n${NC}"

	if [ -f "CMakeLists.txt" ]; then
		printf "Append to exists CMakeLists.txt\n${NC}"
	else
		cp "$TEMPLATE_DIR/debug.h" "."
		cp "$TEMPLATE_DIR/CMakeLists.txt" "."
	fi

	CMAKE_FILE="CMakeLists".txt
	echo "" >>$CMAKE_FILE
	echo "add_executable($PROBLEM_NAME $PROBLEM_NAME.cpp)" >>$CMAKE_FILE
	echo "target_precompile_headers($PROBLEM_NAME REUSE_FROM template)" >>$CMAKE_FILE

	# target_include_directories($PROBLEM_NAME PRIVATE ./)" >> $CMAKE_FILE
	# if [ "$PROBLEM_NAME" == "$ROOT_NAME" ]; then
	#     echo "target_precompile_headers($PROBLEM_NAME
	#     PUBLIC
	#       /usr/include/x86_64-linux-gnu/c++/11/bits/stdc++.h
	#     )" >> $CMAKE_FILE
	# else
	# fi
elif [ "$LANG" == "java" ]; then
	cp -r "$TEMPLATE_DIR/Template.java" "$filepath/"
	sed -i 's/Template/'$PROBLEM_NAME'/' "$filepath/"Template.java
	mv "$filepath/"Template.java "$filepath/$PROBLEM_NAME".java
	echo "created $PROBLEM_NAME.java file"
elif [ "$LANG" == "python" ]; then
	cp -r "$TEMPLATE_DIR/template.py" "./"
	mv template.py "$PROBLEM_NAME".py
	echo "created $PROBLEM_NAME.py file"
fi

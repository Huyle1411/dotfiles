#!/usr/bin/env bash
export RED='\033[0;31m'
export GREEN='\033[0;32m'

export NC='\033[0m' # No Color
TEMPLATE_DIR='/home/huyle/.template'
SUPPORTED_EXTENSION=(cpp cc py java)

problem_name=$1
extension=$2

if [ -z "$extension" ]; then
	extension="cpp" #default
fi

found_valid_extension=0
for ext in "${SUPPORTED_EXTENSION[@]}"; do
	if [ "$extension" = "$ext" ]; then
		found_valid_extension=1
	fi
done

if [ $found_valid_extension -eq 0 ]; then
	echo "Extension is not supported: ${extension}"
	exit 1
fi

if [ ! -d "$problem_name" ]; then
	mkdir -p "${problem_name}"
fi

if [ ! -d "${problem_name}/test" ]; then
	mkdir -p "${problem_name}/test"
fi

if [ ! -f "${problem_name}/${problem_name}.${extension}" ]; then
	# Copy template file
	cp "${TEMPLATE_DIR}/template.${extension}" "${problem_name}/${problem_name}.${extension}"
fi

# TODO: java need the same class name as file name
if [ "${extension}" == "java" ]; then
	# sed -i 's/Template/'$PROBLEM_NAME'/' "$filepath/"Template.java
	echo "need to change class name"
fi

# unused code, only use if using cmake
if false; then
	if [ -f "CMakeLists.txt" ]; then
		printf "Append to exists CMakeLists.txt\n"
	else
		cp "$TEMPLATE_DIR/debug.h" "."
		cp "$TEMPLATE_DIR/CMakeLists.txt" "."
	fi

	CMAKE_FILE="CMakeLists".txt

	if grep -q "$PROBLEM_NAME $PROBLEM_NAME.cc" $CMAKE_FILE; then
		echo "Target already included"
	else
		TARGETCOMMAND="\n"
		TARGETCOMMAND+="add_executable($PROBLEM_NAME $PROBLEM_NAME.cc)\n"
		TARGETCOMMAND+="target_precompile_headers($PROBLEM_NAME REUSE_FROM template)"
		echo -e $TARGETCOMMAND >>$CMAKE_FILE
	fi
fi

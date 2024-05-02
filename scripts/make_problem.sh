#!/usr/bin/env bash
YELLOW="\e[1;33m"

RESET='\e[0m' # No Color
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

if [ "${extension}" == "java" ]; then
	# TODO: java need the same class name as file name
	# sed -i 's/Template/'$PROBLEM_NAME'/' "$filepath/"Template.java
	echo "need to change class name"
elif [ "${extension}" == "cpp" ] || [ "${extension}" == "cc" ]; then
	if [ ! -f "CMakeLists.txt" ]; then
		cp "$TEMPLATE_DIR/CMakeLists.txt" "."
	fi

	if [ ! -f "template.${extension}" ]; then
		cp "$TEMPLATE_DIR/template.${extension}" "."
	fi

	CMAKE_FILE="CMakeLists".txt

	if grep -q "add_executable(${problem_name}" $CMAKE_FILE; then
		echo -e "${YELLOW}Target already included${RESET}"
	else
		TARGETCOMMAND="\n"
		TARGETCOMMAND+="add_executable(${problem_name} ${problem_name}/${problem_name}.${extension})\n"
		TARGETCOMMAND+="target_precompile_headers(${problem_name} REUSE_FROM template)"
		echo -e "$TARGETCOMMAND" >>"$CMAKE_FILE"
	fi
fi

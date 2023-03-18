#!/bin/bash
filename=$(basename -- "$1")
extension="${filename##*.}"
filename="${filename%.*}"

CXXFLAGS="-g -std=c++2a -O2 -Wall -Wextra -pedantic -Wshadow -Wformat=2 -Wfloat-equal -Wconversion -Wlogical-op -Wshift-overflow=2 -Wduplicated-cond -Wcast-qual -Wcast-align -Wno-unused-result -Wno-sign-conversion"
DEBUG_CXXFLAGS="-fsanitize=address -fsanitize=undefined -fsanitize=float-divide-by-zero -fsanitize=float-cast-overflow -fno-sanitize-recover=all -fstack-protector-all -D_FORTIFY_SOURCE=2"
DEBUG_LOCAL_CXXFLAGS="-DDEBUG"

DEBUG=1

if [[ "$2" == "--nodebug" || "$2" == "-nd" ]]; then
	DEBUG=0
fi

if [[ $DEBUG -eq 1 ]]; then
	echo "the DEBUG flags is on"
	CXXFLAGS+=" ${DEBUG_CXXFLAGS} ${DEBUG_LOCAL_CXXFLAGS}"
fi

g++ $CXXFLAGS -o $filename $filename.cpp

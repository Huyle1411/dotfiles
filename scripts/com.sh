#!/bin/bash
filename=$(basename -- "$1")
extension="${filename##*.}"
filename="${filename%.*}"

COMMAND="env time -v g++ -std=c++2a -O0 -Wall -Wextra -Wno-unused-result -Wno-char-subscripts -Wshadow -Wfloat-equal -Wconversion -Wformat-signedness -Wvla -Wduplicated-cond -Wlogical-op -Wredundant-decls -ggdb3 -D_GLIBCXX_DEBUG -D_GLIBCXX_DEBUG_PEDANTIC -D_FORTIFY_SOURCE=2 -fsanitize=undefined,address,float-divide-by-zero,float-cast-overflow -fno-omit-frame-pointer -fno-optimize-sibling-calls -fstack-protector-all -fno-sanitize-recover=all"

$COMMAND -o $filename $filename.cc

cmake_minimum_required(VERSION 3.10)

# set the project name
project(SOLUTION)

# specify the C++ standard
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CXX_FLAGS
    "-std=c++2a -O0 -Wall -Wextra -Wno-unused-result -Wno-char-subscripts -Wshadow -Wfloat-equal -Wconversion -Wformat-signedness -Wvla -Wduplicated-cond -Wlogical-op -Wredundant-decls -Winvalid-pch"
)
set(DEBUG_CXX_FLAGS
    "-ggdb3 -D_GLIBCXX_DEBUG -D_GLIBCXX_DEBUG_PEDANTIC -D_FORTIFY_SOURCE=2 -fsanitize=undefined,address,float-divide-by-zero,float-cast-overflow -fno-omit-frame-pointer -fno-optimize-sibling-calls -fstack-protector-all -fno-sanitize-recover=all"
)
set(DEBUG_LOCAL_CXX_FLAGS "-DDEBUG")

set(CMAKE_CXX_FLAGS "${CXX_FLAGS} ${DEBUG_CXX_FLAGS} ${DEBUG_LOCAL_CXX_FLAGS}")

# generate compilation database
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include_directories(~/.template/)
add_executable(template template.cpp)
target_precompile_headers(template PUBLIC
                          /usr/include/x86_64-linux-gnu/c++/11/bits/stdc++.h)

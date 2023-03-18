cmake_minimum_required(VERSION 3.10)

# set the project name
project(SOLUTION)

# specify the C++ standard
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CXXFLAGS "-g -std=c++2a -O2 -Wall -Wextra -pedantic -Wshadow -Wformat=2 -Wfloat-equal -Wconversion -Wlogical-op -Wshift-overflow=2 -Wduplicated-cond -Wcast-qual -Wcast-align -Wno-unused-result -Wno-sign-conversion")
set(DEBUG_CXXFLAGS "-fsanitize=address -fsanitize=undefined -fsanitize=float-divide-by-zero -fsanitize=float-cast-overflow -fno-sanitize-recover=all -fstack-protector-all -D_FORTIFY_SOURCE=2")
set(DEBUG_LOCAL_CXXFLAGS "-DDEBUG")

set(CMAKE_CXX_FLAGS "${CXXFLAGS} ${DEBUG_CXXFLAGS} ${DEBUG_LOCAL_CXXFLAGS}")

# generate compilation database
set( CMAKE_EXPORT_COMPILE_COMMANDS ON )

include_directories(./)
add_executable(template template.cpp)
target_precompile_headers(template
    PUBLIC
      /usr/include/x86_64-linux-gnu/c++/11/bits/stdc++.h
  )


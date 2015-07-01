cmake_minimum_required(VERSION 3.0.2)
set(CMAKE_CONFIGURATION_TYPES Debug Release)

option(BUILD_SHARED_LIBS "Build shared libraries (DLLs)." ON)

if (UNIX)
	set(CMAKE_CXX_FLAGS_DEBUG 	"${CMAKE_CXX_FLAGS_DEBUG} -g -Wno-ignored-attributes -Wno-deprecated -Wno-shift-op-parentheses -fexceptions")
	set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -Wall -O3")
	set(CMAKE_LINKER 			"/usr/bin/llvm-ld")
	set(CMAKE_CXX_COMPILER 		"/usr/bin/clang++")
	set(CMAKE_C_COMPILER 		"/usr/bin/clang")
	# Verbose output linking
	#set(CMAKE_EXE_LINKER_FLAGS 	"-v")

	add_compile_options(-stdlib=libc++)
	add_compile_options(-std=c++1y)
	add_compile_options(-m64)
endif(UNIX)
if (NOT UNIX)
	# Parallel compilation in Visual Studio
	SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /MP /D \"_CRT_SECURE_NO_WARNINGS\"")

	# Ignore the "PDB not found" linker error and fix warning LNK4098: defaultlib 'msvcrt.lib' conflicts with use of other libs
	SET(CMAKE_SHARED_LINKER_FLAGS_DEBUG "${CMAKE_SHARED_LINKER_FLAGS_DEBUG} /ignore:4099 /NODEFAULTLIB:\"MSVCRT\"")
	SET(CMAKE_SHARED_LINKER_FLAGS_RELEASE "${CMAKE_SHARED_LINKER_FLAGS_RELEASE} /ignore:4099 /NODEFAULTLIB:\"MSVCRTD\"")
	SET(CMAKE_EXE_LINKER_FLAGS_DEBUG "${CMAKE_EXE_LINKER_FLAGS_DEBUG} /NODEFAULTLIB:\"MSVCRT\"")
	SET(CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE} /NODEFAULTLIB:\"MSVCRTD\"")
endif(NOT UNIX)

# I name thee
project(InputTest)

# Define a variable for the root of the project (Not the project file)
set(ProjectRoot ${InputTest_SOURCE_DIR}/)
get_filename_component(ProjectRootAbsolute ${ProjectRoot} ABSOLUTE)

# Include directory
file(RELATIVE_PATH IncludeDirectoryRelative ${InputTest_SOURCE_DIR} ${ProjectRootAbsolute}/include)
get_filename_component(IncludeDirectoryAbsolute ${IncludeDirectoryRelative} ABSOLUTE)

# Library directory
file(RELATIVE_PATH LibraryDirectoryRelative ${InputTest_SOURCE_DIR} ${ProjectRootAbsolute}/lib/64-bit)
get_filename_component(LibraryDirectoryAbsolute ${LibraryDirectoryRelative} ABSOLUTE)

# Project settings
if (NOT CMAKE_BUILD_TYPE)
	set(CMAKE_BUILD_TYPE Debug)
endif()
string(TOLOWER ${CMAKE_SYSTEM_NAME} OperatingSystemNameLowerCase)
if(MSVC)
	set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${ProjectRoot}/bin/${OperatingSystemNameLowerCase}/)
endif(MSVC)
if(UNIX)
	set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${ProjectRoot}/bin/${OperatingSystemNameLowerCase}/${CMAKE_BUILD_TYPE})
endif(UNIX)

set(TargetArchitecture "x86_64")

# Find SDL2
find_path(SDL2Include SDL2/SDL.h
	PATHS ${IncludeDirectoryAbsolute})
set(SDL2Includes ${SDL2Include})
find_library(SDL2Library
	NAMES SDL2 SDL2main
	PATHS ${LibraryDirectoryAbsolute})
set(SDL2Libraries ${SDL2Library})
if (MSVC)
	find_library(SDL2mainLibrary
		NAMES SDL2main
		PATHS ${LibraryDirectoryAbsolute})
	list(APPEND SDL2Libraries ${SDL2mainLibrary})
endif(MSVC)

link_directories(
	${LibraryDirectoryRelative}
)

if (UNIX)
	list(APPEND standardLibraries "c++")
	list(APPEND standardLibraries "c++abi")
endif(UNIX)

include_directories(
	${SDL2Includes}
	${IncludeDirectoryRelative}
	${ProjectRoot}/src/
)

set(BUILD_PREFIX_PATH build/${BUILD_PREFIX_NAME}\ ${CMAKE_BUILD_TYPE})
set(USE_CUSTOM_ALLOCATOR_HEADER_FOR_INPUT false)

# Add each separate library/executable
add_subdirectory(src/input 				${BUILD_PREFIX_PATH}/input)
add_subdirectory(src/utility 			${BUILD_PREFIX_PATH}/utility)
add_subdirectory(src/input/demo			${BUILD_PREFIX_PATH}/input/demo)

cmake_minimum_required(VERSION 2.8.12 FATAL_ERROR)

project(goesdec CXX C)

string(TOLOWER "${CMAKE_GENERATOR_PLATFORM}" GENERATOR_LOWER)
if("${GENERATOR_LOWER}" STREQUAL "x64")
  include_directories(vcpkg/installed/x64-windows/include)
  link_directories(vcpkg/installed/x64-windows/lib)
elseif("${GENERATOR_LOWER}" STREQUAL "arm64")
  include_directories(vcpkg/installed/arm64-windows/include)
  link_directories(vcpkg/installed/arm64-windows/lib)
else()
  include_directories(vcpkg/installed/x86-windows/include)
  link_directories(vcpkg/installed/x86-windows/lib)
endif()

if(SANITIZE_ADDRESS OR SANITIZE_MEMORY OR
    SANITIZE_THREAD OR SANITIZE_UNDEFINED)
  set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/vendor/sanitizers-cmake/cmake ${CMAKE_MODULE_PATH})
  find_package(Sanitizers)
else()
  function(add_sanitizers)
  endfunction()
endif()

# Force static build of libaec
set(BUILD_SHARED_LIBS OFF CACHE INTERNAL "" FORCE)

# Set a default build type if none was specified
set(default_build_type "Release")
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message(STATUS "Defaulting build type to '${default_build_type}'")
  set(CMAKE_BUILD_TYPE "${default_build_type}" CACHE
    STRING "Choose the type of build." FORCE)
  # Set the possible values of build type for cmake-gui
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
    "Debug" "Release" "MinSizeRel")
endif()

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DNOMINMAX -DNOGDI")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DNOMINMAX -DNOGDI")
if("${CMAKE_BUILD_TYPE}" EQUAL "Release")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O3")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3")
endif()

add_subdirectory(vendor/libcorrect EXCLUDE_FROM_ALL)

include_directories(BEFORE SYSTEM ${PROJECT_BINARY_DIR}/include)
include_directories(BEFORE SYSTEM ${PROJECT_SOURCE_DIR}/vendor/libcorrect/include)
include_directories(BEFORE SYSTEM ${PROJECT_SOURCE_DIR}/vendor/tinytoml/include)
include_directories(${PROJECT_SOURCE_DIR}/src)

add_subdirectory(src/util)
add_subdirectory(src/lib)
add_subdirectory(src/lrit)
add_subdirectory(src/dcs)
add_subdirectory(src/decoder)
add_subdirectory(src/assembler)

option(BUILD_GOESRECV "Build goesrecv" ON)
if(${BUILD_GOESRECV})
  add_subdirectory(src/goesrecv)
endif()

option(BUILD_GOESLRIT "Build goeslrit" ON)
if(${BUILD_GOESLRIT})
  add_subdirectory(src/goeslrit)
endif()

# Legacy - Building Anyway
option(BUILD_GOESEMWIN "Build goesemwin" ON)
if(${BUILD_GOESEMWIN})
  add_subdirectory(src/goesemwin)
endif()

option(BUILD_GOESPROC "Build goesproc" ON)
if(${BUILD_GOESPROC})
  add_subdirectory(src/goesproc)

  # Install contrast curve and false color LUT
  install(
    DIRECTORY share/wxstar
    DESTINATION share/goestools
    COMPONENT goestools)

  # Install Natural Earth GeoJSON files for map overlays
  install(
    DIRECTORY share/ne
    DESTINATION share/goestools
    COMPONENT goestools)
endif()

option(BUILD_GOESPACKETS "Build goespackets" ON)
if(${BUILD_GOESPACKETS})
  add_subdirectory(src/goespackets)
endif()

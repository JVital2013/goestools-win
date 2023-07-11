find_package(nlohmann_json CONFIG REQUIRED)
add_library(lrit lrit.cc file.cc json.cc)
target_link_libraries(lrit util nlohmann_json::nlohmann_json)

add_executable(lritdump lritdump.cc)
find_library(GETOPT_LIB getopt)
add_sanitizers(lritdump)
target_link_libraries(lritdump lrit ${GETOPT_LIB})

add_executable(areadump areadump.cc)
add_sanitizers(areadump)
find_library(SHLWAPI_LIB shlwapi)
target_link_libraries(areadump lrit dir ${SHLWAPI_LIB})

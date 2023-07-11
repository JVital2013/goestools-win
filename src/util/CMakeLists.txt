add_library(util fs.cc string.cc time.cc strptime.cc)
target_include_directories(util PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/..)

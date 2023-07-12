set(GOESPROC_SRCS
  area.cc
  config.cc
  filename.cc
  file_writer.cc
  goesproc.cc
  gradient.cc
  handler_emwin.cc
  handler_goesn.cc
  handler_goesr.cc
  handler_himawari8.cc
  handler_nws_image.cc
  handler_nws_text.cc
  handler_text.cc
  image.cc
  lrit_processor.cc
  options.cc
  packet_processor.cc
  string.cc
  proj.cc
  map_drawer.cc
  )
  
find_package(PROJ CONFIG REQUIRED)
find_package(OpenCV CONFIG REQUIRED)
find_package(nlohmann_json CONFIG REQUIRED)
find_library(GETOPT_LIB getopt)

add_executable(goesproc ${GOESPROC_SRCS})
add_sanitizers(goesproc)
install(TARGETS goesproc COMPONENT goestools RUNTIME DESTINATION bin)
target_link_libraries(goesproc lrit util assembler packet_reader dir shlwapi ${GETOPT_LIB})
target_link_libraries(goesproc zip)
target_link_libraries(goesproc nlohmann_json::nlohmann_json)
target_link_libraries(goesproc timer)
target_link_libraries(goesproc version)
set_target_properties(goesproc PROPERTIES LINK_FLAGS "setargv.obj")

target_link_libraries(goesproc opencv_core opencv_highgui opencv_imgproc)
target_include_directories(goesproc PRIVATE ${OPENCV_INCLUDE_DIRS})
target_link_libraries(goesproc opencv_imgcodecs)

string(REPLACE "." ";" PROJ_VERSION_LIST ${PROJ_VERSION})
list(GET PROJ_VERSION_LIST 0 PROJ_VERSION_MAJOR)
list(GET PROJ_VERSION_LIST 1 PROJ_VERSION_MINOR)
list(GET PROJ_VERSION_LIST 2 PROJ_VERSION_PATCH)
target_compile_definitions(goesproc PRIVATE
PROJ_VERSION_MAJOR=${PROJ_VERSION_MAJOR}
PROJ_VERSION_MINOR=${PROJ_VERSION_MINOR}
PROJ_VERSION_PATCH=${PROJ_VERSION_PATCH})
target_compile_definitions(goesproc PRIVATE HAS_PROJ)
target_link_libraries(goesproc proj)

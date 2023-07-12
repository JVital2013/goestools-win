add_executable(goeslrit goeslrit.cc options.cc)
add_sanitizers(goeslrit)
install(TARGETS goeslrit COMPONENT goestools RUNTIME DESTINATION bin)

find_library(GETOPT_LIB getopt)
target_link_libraries(goeslrit assembler nanomsg packet_reader util ${GETOPT_LIB})
target_link_libraries(goeslrit version)
set_target_properties(goeslrit PROPERTIES LINK_FLAGS "setargv.obj")
add_library(dcs dcs.cc)
find_library(GETOPT_LIB getopt)

add_executable(dcsdump dcsdump.cc)
add_sanitizers(dcsdump)
target_link_libraries(dcsdump lrit dcs ${GETOPT_LIB})
set_target_properties(dcsdump PROPERTIES LINK_FLAGS "setargv.obj")
find_package(nanomsg CONFIG REQUIRED)
add_library(publisher
  packet_publisher.cc
  publisher.cc
  sample_publisher.cc
  soft_bit_publisher.cc
  stats_publisher.cc
  )
target_link_libraries(publisher nanomsg)

find_library(AIRSPY_LIB airspy)
add_library(airspy_source airspy_source.cc)
target_link_libraries(airspy_source ${AIRSPY_LIB} publisher)

find_package(rtlsdr CONFIG REQUIRED)
add_library(rtlsdr_source rtlsdr_source.cc)
target_link_libraries(rtlsdr_source rtlsdr::rtlsdr publisher)

add_library(nanomsg_source nanomsg_source.cc)
target_link_libraries(nanomsg_source nanomsg publisher)

add_library(agc agc.cc)
target_link_libraries(agc publisher)

add_library(rrc rrc.cc)
target_link_libraries(rrc publisher)

add_library(costas costas.cc)
target_link_libraries(costas publisher)

add_library(clock_recovery clock_recovery.cc)
target_link_libraries(clock_recovery publisher)

add_library(quantize quantize.cc)
target_link_libraries(quantize publisher)

find_package(nlohmann_json CONFIG REQUIRED)
find_library(GETOPT_LIB getopt)
add_executable(goesrecv goesrecv.cc config.cc options.cc decoder.cc demodulator.cc monitor.cc datagram_socket.cc source.cc)
install(TARGETS goesrecv COMPONENT goestools RUNTIME DESTINATION bin)
target_include_directories(goesrecv PRIVATE ${PROJECT_SOURCE_DIR}/src)
target_link_libraries(goesrecv util)
target_link_libraries(goesrecv nlohmann_json::nlohmann_json ${GETOPT_LIB})
target_link_libraries(goesrecv packetizer)
target_link_libraries(goesrecv agc)
target_link_libraries(goesrecv rrc)
target_link_libraries(goesrecv costas)
target_link_libraries(goesrecv clock_recovery)
target_link_libraries(goesrecv quantize)
target_link_libraries(goesrecv nanomsg_source)
target_link_libraries(goesrecv version)
target_link_libraries(goesrecv airspy_source)
target_link_libraries(goesrecv rtlsdr_source)

add_executable(benchmark benchmark.cc)
target_link_libraries(benchmark agc)
target_link_libraries(benchmark rrc)
target_link_libraries(benchmark costas)
target_link_libraries(benchmark clock_recovery)

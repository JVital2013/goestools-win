find_package(nanomsg CONFIG REQUIRED)
add_library(publisher
  packet_publisher.cc
  publisher.cc
  sample_publisher.cc
  soft_bit_publisher.cc
  stats_publisher.cc
  )
target_link_libraries(publisher nanomsg)

add_library(airspy_source airspy_source.cc)
target_link_libraries(airspy_source ${AIRSPY_LIBRARIES} publisher)

find_package(rtlsdr CONFIG REQUIRED)
add_library(rtlsdr_source rtlsdr_source.cc)
if((RTLSDR_VERSION VERSION_EQUAL 0.5.4) OR (RTLSDR_VERSION VERSION_GREATER 0.5.4))
  target_compile_definitions(rtlsdr_source PRIVATE RTLSDR_HAS_BIAS_TEE)
endif()
target_link_libraries(rtlsdr_source ${RTLSDR_LIBRARIES} publisher)

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

add_executable(goesrecv goesrecv.cc config.cc options.cc decoder.cc demodulator.cc monitor.cc datagram_socket.cc source.cc)
install(TARGETS goesrecv COMPONENT goestools RUNTIME DESTINATION bin)
target_include_directories(goesrecv PRIVATE ${PROJECT_SOURCE_DIR}/src)
target_link_libraries(goesrecv util)
target_link_libraries(goesrecv nlohmann_json)
target_link_libraries(goesrecv packetizer)
target_link_libraries(goesrecv agc)
target_link_libraries(goesrecv rrc)
target_link_libraries(goesrecv costas)
target_link_libraries(goesrecv clock_recovery)
target_link_libraries(goesrecv quantize)
target_link_libraries(goesrecv nanomsg_source)
target_link_libraries(goesrecv version)
if(AIRSPY_FOUND)
  target_compile_definitions(goesrecv PUBLIC -DBUILD_AIRSPY)
  target_link_libraries(goesrecv airspy_source)
endif()
if(RTLSDR_FOUND)
  target_compile_definitions(goesrecv PUBLIC -DBUILD_RTLSDR)
  target_link_libraries(goesrecv rtlsdr_source)
endif()

add_executable(benchmark benchmark.cc)
target_link_libraries(benchmark agc)
target_link_libraries(benchmark rrc)
target_link_libraries(benchmark costas)
target_link_libraries(benchmark clock_recovery)

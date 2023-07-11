add_executable(packetinfo packetinfo.cc)
find_library(SZIP_LIB szip)
find_library(AEC_LIB aec)
add_library(assembler
  assembler.cc
  crc.cc
  session_pdu.cc
  transport_pdu.cc
  virtual_channel.cc
  )
target_link_libraries(assembler lrit ${SZIP_LIB} ${AEC_LIB})

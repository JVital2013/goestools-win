# Goestools for Windows
Port of Goestools for Windows. Compiled releases will be available in a day or two!

### Known to work:
- goesrecv
- goesproc
- goeslrit
- lritdump
- areadump
- goespackets
- packetinfo
- benchmark
- compute_sync_words
- dcsdump - Old DCS lrit files only. New ones don't work on Linux either.
- unzip - Can extract zips with a single file in it, like the data section of NWS/EMWIN lrit image files. For debugging purposes.

### Untested
- goesproc with GOES-N data - goesproc has been validated against GOES-R data only
- packetdump - takes LRIT packets into STDIN and does some analysis. Tricky to use on windows, but would probably work.

### Does not work
- goesemwin - No longer needed as there are no GOES-N satellites with LRIT/EMWIN active. EMWIN for GOES-R works fine via goesproc. It should be easy to fix if needed in the future.

## Compiling
May the odds be ever in your favor

### Configure Visual Studio
Install Visual Studio Community 2022 (Free)
Install CMake, Git, MORE HERE

### Configure vcpkg
Open the Developer Command Prompt for VS 2022
```
cd C:\
git clone https://github.com/microsoft/vcpkg
cd vcpkg
bootstrap-vcpkg.bat
vcpkg install opencv:x64-windows
vcpkg install proj:x64-windows
vcpkg install rtlsdr:x64-windows
vcpkg install dirent:x64-windows
vcpkg install getopt-win32:x64-windows
vcpkg install nanomsg:x64-windows
vcpkg install nlohmann-json:x64-windows
```

MORE HERE - COMPILE LIBAEC AND COPY INTO VCPKG

### AirSpy Library (Thanks @Aang23!)
```
cd C:\vcpkg\installed\x64-windows\bin
curl -LJO https://github.com/Aang23/vcpkg/raw/master/installed/x64-windows/bin/airspy.dll
curl -LJO https://github.com/Aang23/vcpkg/raw/master/installed/x64-windows/bin/airspyhf.dll
curl -LJO https://github.com/Aang23/vcpkg/raw/master/installed/x64-windows/bin/pthreadVC2.dll
cd C:\vcpkg\installed\x64-windows\lib
curl -LJO https://github.com/Aang23/vcpkg/raw/master/installed/x64-windows/lib/airspy.lib
curl -LJO https://github.com/Aang23/vcpkg/raw/master/installed/x64-windows/lib/airspyhf.lib

mkdir C:\vcpkg\installed\x64-windows\include\libairspy
cd C:\vcpkg\installed\x64-windows\include\libairspy
curl -LJO https://github.com/Aang23/vcpkg/raw/master/installed/x64-windows/include/libairspy/airspy.h
curl -LJO https://github.com/Aang23/vcpkg/raw/master/installed/x64-windows/include/libairspy/airspy_commands.h
curl -LJO https://github.com/Aang23/vcpkg/raw/master/installed/x64-windows/include/libairspy/filters.h
curl -LJO https://github.com/Aang23/vcpkg/raw/master/installed/x64-windows/include/libairspy/iqconvert_float.h
curl -LJO https://github.com/Aang23/vcpkg/raw/master/installed/x64-windows/include/libairspy/iqconvert_int16.h

mkdir C:\vcpkg\installed\x64-windows\include\libairspyhf
cd C:\vcpkg\installed\x64-windows\include\libairspyhf
curl -LJO https://github.com/Aang23/vcpkg/raw/master/installed/x64-windows/include/libairspyhf/airspyhf.h
curl -LJO https://github.com/Aang23/vcpkg/raw/master/installed/x64-windows/include/libairspyhf/airspyhf_commands.h
curl -LJO https://github.com/Aang23/vcpkg/raw/master/installed/x64-windows/include/libairspyhf/iqbalancer.h
```

### Download and patch goestools
```
cd C:\
git clone -b windows --recursive https://github.com/JVital2013/goestools
cd goestools
```

### Compile goestools
```
mkdir build && cd build
cmake .. "-DCMAKE_TOOLCHAIN_FILE=C:/vcpkg/scripts/buildsystems/vcpkg.cmake" -G "Visual Studio 17 2022"
cmake --build . --config Release
TODO: Copy proj.db into place
```

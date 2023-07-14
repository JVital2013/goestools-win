if(!!(Get-Command 'tf' -ErrorAction SilentlyContinue) -eq $false)
{
    Write-Error "You must run this script within Developer Powershell for Visual Studio"
    exit
}

$vcpkg = "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vcpkg"
if(Test-Path "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vcpkg" -ErrorAction SilentlyContinue)
{
    Write-Output "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vcpkg already found! Not setting up."
    exit
}

Write-Output "Configuing vcpkg..."
cd "$(Split-Path -Parent $MyInvocation.MyCommand.Path)"
git clone https://github.com/microsoft/vcpkg
cd vcpkg
git checkout 7771648 #Force a known working version
.\bootstrap-vcpkg.bat
.\vcpkg.exe install opencv:x64-windows proj:x64-windows rtlsdr:x64-windows dirent:x64-windows getopt-win32:x64-windows nanomsg:x64-windows nlohmann-json:x64-windows

#Install libaec
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libaec\*.dll" "$vcpkg\installed\x64-windows\bin"
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libaec\*.lib" "$vcpkg\installed\x64-windows\lib"
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libaec\*.h" "$vcpkg\installed\x64-windows\include"

#AirSpy Library (thanks @Aang23!)
cd "$vcpkg\installed\x64-windows\bin"
curl.exe -LJO https://github.com/Aang23/vcpkg/raw/master/installed/x64-windows/bin/airspy.dll
curl.exe -LJO https://github.com/Aang23/vcpkg/raw/master/installed/x64-windows/bin/airspyhf.dll
curl.exe -LJO https://github.com/Aang23/vcpkg/raw/master/installed/x64-windows/bin/pthreadVC2.dll
cd "$vcpkg\installed\x64-windows\lib"
curl.exe -LJO https://github.com/Aang23/vcpkg/raw/master/installed/x64-windows/lib/airspy.lib
curl.exe -LJO https://github.com/Aang23/vcpkg/raw/master/installed/x64-windows/lib/airspyhf.lib

mkdir "$vcpkg\installed\x64-windows\include\libairspy"
cd "$vcpkg\installed\x64-windows\include\libairspy"
curl.exe -LJO https://github.com/Aang23/vcpkg/raw/master/installed/x64-windows/include/libairspy/airspy.h
curl.exe -LJO https://github.com/Aang23/vcpkg/raw/master/installed/x64-windows/include/libairspy/airspy_commands.h
curl.exe -LJO https://github.com/Aang23/vcpkg/raw/master/installed/x64-windows/include/libairspy/filters.h
curl.exe -LJO https://github.com/Aang23/vcpkg/raw/master/installed/x64-windows/include/libairspy/iqconvert_float.h
curl.exe -LJO https://github.com/Aang23/vcpkg/raw/master/installed/x64-windows/include/libairspy/iqconvert_int16.h

mkdir "$vcpkg\installed\x64-windows\include\libairspyhf"
cd "$vcpkg\installed\x64-windows\include\libairspyhf"
curl.exe -LJO https://github.com/Aang23/vcpkg/raw/master/installed/x64-windows/include/libairspyhf/airspyhf.h
curl.exe -LJO https://github.com/Aang23/vcpkg/raw/master/installed/x64-windows/include/libairspyhf/airspyhf_commands.h
curl.exe -LJO https://github.com/Aang23/vcpkg/raw/master/installed/x64-windows/include/libairspyhf/iqbalancer.h

Write-Output "Done!"
cd "$(Split-Path -Parent $MyInvocation.MyCommand.Path)"
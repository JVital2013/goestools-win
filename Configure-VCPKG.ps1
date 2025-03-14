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
git checkout 2025.02.14 #Force a known working version
.\bootstrap-vcpkg.bat
.\vcpkg.exe install --triplet x64-windows opencv proj dirent getopt-win32 nanomsg nlohmann-json libusb pthreads
.\vcpkg.exe install --triplet x86-windows opencv proj dirent getopt-win32 nanomsg nlohmann-json libusb pthreads
.\vcpkg.exe install --triplet arm64-windows opencv proj dirent getopt-win32 nanomsg nlohmann-json libusb pthreads

#Install libusb with Raw IO
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libusb\x64\*.dll" "$vcpkg\installed\x64-windows\bin"
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libusb\x64\*.pdb" "$vcpkg\installed\x64-windows\bin"
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libusb\x64\*.lib" "$vcpkg\installed\x64-windows\lib"

cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libusb\x86\*.dll" "$vcpkg\installed\x86-windows\bin"
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libusb\x86\*.pdb" "$vcpkg\installed\x86-windows\bin"
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libusb\x86\*.lib" "$vcpkg\installed\x86-windows\lib"

cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libusb\arm64\*.dll" "$vcpkg\installed\arm64-windows\bin"
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libusb\arm64\*.pdb" "$vcpkg\installed\arm64-windows\bin"
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libusb\arm64\*.lib" "$vcpkg\installed\arm64-windows\lib"

cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libusb\libusb.h" "$vcpkg\installed\x64-windows\include\libusb-1.0"
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libusb\libusb.h" "$vcpkg\installed\x86-windows\include\libusb-1.0"
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libusb\libusb.h" "$vcpkg\installed\arm64-windows\include\libusb-1.0"

#Install libairspy
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libairspy\x64\*.dll" "$vcpkg\installed\x64-windows\bin"
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libairspy\x64\*.lib" "$vcpkg\installed\x64-windows\lib"

cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libairspy\x86\*.dll" "$vcpkg\installed\x86-windows\bin"
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libairspy\x86\*.lib" "$vcpkg\installed\x86-windows\lib"

cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libairspy\arm64\*.dll" "$vcpkg\installed\arm64-windows\bin"
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libairspy\arm64\*.lib" "$vcpkg\installed\arm64-windows\lib"

cp -r "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libairspy\libairspy" "$vcpkg\installed\x64-windows\include"
cp -r "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libairspy\libairspy" "$vcpkg\installed\x86-windows\include"
cp -r "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libairspy\libairspy" "$vcpkg\installed\arm64-windows\include"

#Install rtlsdr
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\librtlsdr\x64\*.dll" "$vcpkg\installed\x64-windows\bin"
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\librtlsdr\x64\*.lib" "$vcpkg\installed\x64-windows\lib"

cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\librtlsdr\x86\*.dll" "$vcpkg\installed\x86-windows\bin"
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\librtlsdr\x86\*.lib" "$vcpkg\installed\x86-windows\lib"

cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\librtlsdr\arm64\*.dll" "$vcpkg\installed\arm64-windows\bin"
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\librtlsdr\arm64\*.lib" "$vcpkg\installed\arm64-windows\lib"

cp -r "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\librtlsdr\*.h" "$vcpkg\installed\x64-windows\include"
cp -r "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\librtlsdr\*.h" "$vcpkg\installed\x86-windows\include"
cp -r "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\librtlsdr\*.h" "$vcpkg\installed\arm64-windows\include"

#Install libaec
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libaec\x64\*.dll" "$vcpkg\installed\x64-windows\bin"
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libaec\x64\*.lib" "$vcpkg\installed\x64-windows\lib"

cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libaec\x86\*.dll" "$vcpkg\installed\x86-windows\bin"
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libaec\x86\*.lib" "$vcpkg\installed\x86-windows\lib"

cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libaec\arm64\*.dll" "$vcpkg\installed\arm64-windows\bin"
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libaec\arm64\*.lib" "$vcpkg\installed\arm64-windows\lib"

cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libaec\*.h" "$vcpkg\installed\x64-windows\include"
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libaec\*.h" "$vcpkg\installed\x86-windows\include"
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libaec\*.h" "$vcpkg\installed\arm64-windows\include"

Write-Output "Done!"
cd "$(Split-Path -Parent $MyInvocation.MyCommand.Path)"
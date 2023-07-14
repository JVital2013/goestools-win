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
.\vcpkg.exe install --triplet x64-windows opencv proj rtlsdr dirent getopt-win32 nanomsg nlohmann-json
.\vcpkg.exe install --triplet x86-windows opencv proj rtlsdr dirent getopt-win32 nanomsg nlohmann-json

#Install libaec
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libaec\x64\*.dll" "$vcpkg\installed\x64-windows\bin"
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libaec\x64\*.lib" "$vcpkg\installed\x64-windows\lib"
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libaec\x86\*.dll" "$vcpkg\installed\x86-windows\bin"
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libaec\x86\*.lib" "$vcpkg\installed\x86-windows\lib"
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libaec\*.h" "$vcpkg\installed\x64-windows\include"
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libaec\*.h" "$vcpkg\installed\x86-windows\include"

#Install libairspy
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libairspy\x64\*.dll" "$vcpkg\installed\x64-windows\bin"
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libairspy\x64\*.lib" "$vcpkg\installed\x64-windows\lib"
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libairspy\x86\*.dll" "$vcpkg\installed\x86-windows\bin"
cp "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libairspy\x86\*.lib" "$vcpkg\installed\x86-windows\lib"
cp -r "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libairspy\libairspy" "$vcpkg\installed\x64-windows\include"
cp -r "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vendor\libairspy\libairspy" "$vcpkg\installed\x86-windows\include"

Write-Output "Done!"
cd "$(Split-Path -Parent $MyInvocation.MyCommand.Path)"
if(!!(Get-Command 'tf' -ErrorAction SilentlyContinue) -eq $false)
{
    Write-Error "You must run this script within Developer Powershell for Visual Studio 2022"
    exit
}

$vcpkg = "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\vcpkg"
if(-not $(Test-Path $vcpkg -ErrorAction SilentlyContinue))
{
    Write-Error "Could not find vcpkg at $vcpkg"
    exit
}

#Set up build folder
cd $(Split-Path -Parent $MyInvocation.MyCommand.Path)
Remove-Item build -Force -Recurse -ErrorAction SilentlyContinue | Out-null
mkdir build | Out-null
cd build | Out-null

#Do the build
cmake .. "-DCMAKE_TOOLCHAIN_FILE=$($vcpkg.Replace("\", "/"))/scripts/buildsystems/vcpkg.cmake" -G "Visual Studio 17 2022"
cmake --build . --config Release

#Create the bundle folder and put everything in it
Write-Output "Making distributable folder..."
mkdir dist | Out-Null
cd dist
mkdir bin  | Out-Null
mkdir Saved | Out-Null

cp -Force ..\..\build\src\assembler\Release\*.exe bin/
cp -Force ..\..\build\src\dcs\Release\*.exe bin/
cp -Force ..\..\build\src\dcs\Release\*.dll bin/
cp -Force ..\..\build\src\decoder\Release\*.exe bin/
cp -Force ..\..\build\src\goesemwin\Release\*.exe bin/
cp -Force ..\..\build\src\goesemwin\Release\*.dll bin/
cp -Force ..\..\build\src\goeslrit\Release\*.exe bin/
cp -Force ..\..\build\src\goeslrit\Release\*.dll bin/
cp -Force ..\..\build\src\goespackets\Release\*.exe bin/
cp -Force ..\..\build\src\goespackets\Release\*.dll bin/
cp -Force ..\..\build\src\goesproc\Release\*.exe bin/
cp -Force ..\..\build\src\goesproc\Release\*.dll bin/
cp -Force ..\..\build\src\goesrecv\Release\*.exe bin/
cp -Force ..\..\build\src\goesrecv\Release\*.dll bin/
cp -Force ..\..\build\src\lib\Release\*.exe bin/
cp -Force ..\..\build\src\lib\Release\*.dll bin/
cp -Force ..\..\build\src\lrit\Release\*.exe bin/
cp -Force ..\..\build\src\lrit\Release\*.dll bin/

cp ..\..\README.md .
cp $vcpkg\installed\x64-windows\share\proj\proj.db .
cp -r ..\..\share .
cp -r ..\..\LICENSES .
cp -r ..\..\config .
cp ..\..\scripts\* .

Write-Output "Done! Your build is ready at $($(pwd).path)"
pause
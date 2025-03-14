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

#Do the builds
foreach($arch in $("win32", "x64", "arm64"))
{
    Write-Output "Building for $arch..."
    mkdir "build-$arch" | Out-Null
    cd "build-$arch"
	
	if($arch -eq "win32") { $triplet = "x86-windows" }
	else { $triplet = $arch + "-windows" }
	
	#TODO fix me for ARM
    cmake ..\.. "-DCMAKE_TOOLCHAIN_FILE=$($vcpkg.Replace("\", "/"))/scripts/buildsystems/vcpkg.cmake" -A $arch
    cmake --build . --config Release

    #Create the bundle folder and put everything in it
    Write-Output "Making $arch distributable folder..."
    cd ..
    mkdir "dist-$arch" | Out-Null
    cd "dist-$arch"

    mkdir bin  | Out-Null
    mkdir Saved | Out-Null

    cp -Force ..\build-$arch\src\assembler\Release\*.exe bin/
    cp -Force ..\build-$arch\src\dcs\Release\*.exe bin/
    cp -Force ..\build-$arch\src\dcs\Release\*.dll bin/
    cp -Force ..\build-$arch\src\decoder\Release\*.exe bin/
    cp -Force ..\build-$arch\src\goesemwin\Release\*.exe bin/
    cp -Force ..\build-$arch\src\goesemwin\Release\*.dll bin/
    cp -Force ..\build-$arch\src\goeslrit\Release\*.exe bin/
    cp -Force ..\build-$arch\src\goeslrit\Release\*.dll bin/
    cp -Force ..\build-$arch\src\goespackets\Release\*.exe bin/
    cp -Force ..\build-$arch\src\goespackets\Release\*.dll bin/
    cp -Force ..\build-$arch\src\goesproc\Release\*.exe bin/
    cp -Force ..\build-$arch\src\goesproc\Release\*.dll bin/
    cp -Force ..\build-$arch\src\goesrecv\Release\*.exe bin/
    cp -Force ..\build-$arch\src\goesrecv\Release\*.dll bin/
    cp -Force ..\build-$arch\src\lib\Release\*.exe bin/
    cp -Force ..\build-$arch\src\lib\Release\*.dll bin/
    cp -Force ..\build-$arch\src\lrit\Release\*.exe bin/
    cp -Force ..\build-$arch\src\lrit\Release\*.dll bin/

    cp ..\..\README.md .
    cp $vcpkg\installed\x64-windows\share\proj\proj.db bin/
    cp -r ..\..\share .
    cp -r ..\..\LICENSES .
    cp -r ..\..\config .
    cp ..\..\scripts\* .

    cd ..
}

Write-Output "Done! Your build is ready at $($(pwd).path)"
pause
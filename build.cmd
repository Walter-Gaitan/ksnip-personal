@echo off
rem Builds kColorPicker, kImageAnnotator and ksnip (Release) and packages a runnable app in .\app
rem Usage: build.cmd          full build
rem        build.cmd ksnip    rebuild only ksnip (after changing its code)
setlocal
set ROOT=%~dp0
set ROOT=%ROOT:~0,-1%
set PREFIX=%ROOT%\deps
set QTDIR=C:\Qt\5.15.2\msvc2019_64
set PYSCRIPTS=%APPDATA%\Python\Python314\Scripts

for /f "usebackq tokens=*" %%i in (`"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -products * -property installationPath`) do set VSDIR=%%i
call "%VSDIR%\VC\Auxiliary\Build\vcvars64.bat" >nul || goto :fail

set PATH=%PYSCRIPTS%;%QTDIR%\bin;%PREFIX%\bin;%PATH%
set CMAKE_PREFIX_PATH=%QTDIR%;%PREFIX%
set LIB=%LIB%;%PREFIX%\lib
set INCLUDE=%INCLUDE%;%PREFIX%\include
set COMMON=-G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="%PREFIX%" -DBUILD_WITH_QT6=OFF

if /i "%1"=="ksnip" goto :ksnip

echo === kColorPicker ===
cmake -S "%ROOT%\kColorPicker" -B "%ROOT%\kColorPicker\build" %COMMON% -DBUILD_EXAMPLE=OFF || goto :fail
cmake --build "%ROOT%\kColorPicker\build" --target install || goto :fail

echo === kImageAnnotator ===
cmake -S "%ROOT%\kImageAnnotator" -B "%ROOT%\kImageAnnotator\build" %COMMON% -DBUILD_EXAMPLE=OFF -DCMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES="%PREFIX%\include" || goto :fail
cmake --build "%ROOT%\kImageAnnotator\build" --target install || goto :fail

:ksnip
echo === ksnip ===
cmake -S "%ROOT%\ksnip" -B "%ROOT%\ksnip\build" %COMMON% -DBUILD_TESTS=OFF || goto :fail
cmake --build "%ROOT%\ksnip\build" || goto :fail

echo === package to .\app ===
if not exist "%ROOT%\app" mkdir "%ROOT%\app"
copy /y /b "%ROOT%\ksnip\build\src\ksnip.exe" "%ROOT%\app\ksnip.exe" >nul || goto :fail
for %%d in ("%PREFIX%\bin\*.dll") do copy /y "%%d" "%ROOT%\app\" >nul
windeployqt --no-opengl-sw --no-system-d3d-compiler --no-compiler-runtime --release "%ROOT%\app\ksnip.exe" >nul || goto :fail
rem bundle the C++ runtime so the folder runs on PCs without it installed (portable)
if exist "%ROOT%\app\vc_redist.x64.exe" del "%ROOT%\app\vc_redist.x64.exe"
for /d %%r in ("%VSDIR%\VC\Redist\MSVC\*") do if exist "%%r\x64\Microsoft.VC143.CRT" copy /y "%%r\x64\Microsoft.VC143.CRT\*.dll" "%ROOT%\app\" >nul
echo.
echo Done: %ROOT%\app\ksnip.exe
exit /b 0

:fail
echo BUILD FAILED
exit /b 1

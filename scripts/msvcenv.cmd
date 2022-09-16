@echo off

setlocal

if "%1" equ "" goto usage
set MSVS_VERSION=%1

if "%2" equ "x86" set MY_ARCH=x86
if "%2" equ "x64" set MY_ARCH=x64
if "%MY_ARCH%" equ "" goto usage

if "%MSVS_INSTALL_ROOT%" neq "" set MSVS_INSTALL_ROOT_32=%MSVS_INSTALL_ROOT%
if "%MSVS_INSTALL_ROOT%" neq "" set MSVS_INSTALL_ROOT_62=%MSVS_INSTALL_ROOT%
if "%MSVS_INSTALL_ROOT%" == "" set MSVS_INSTALL_ROOT_32=c:\Program Files (x86)\Microsoft Visual Studio
if "%MSVS_INSTALL_ROOT%" == "" set MSVS_INSTALL_ROOT_64=c:\Program Files\Microsoft Visual Studio

if "%MSVS_VERSION%" equ "2008" set VC_VARS_ALL=%MSVS_INSTALL_ROOT_32% 9.0\VC\vcvarsall.bat
if "%MSVS_VERSION%" equ "2010" set VC_VARS_ALL=%MSVS_INSTALL_ROOT_32% 10.0\VC\vcvarsall.bat
if "%MSVS_VERSION%" equ "2012" set VC_VARS_ALL=%MSVS_INSTALL_ROOT_32% 11.0\VC\vcvarsall.bat
if "%MSVS_VERSION%" equ "2013" set VC_VARS_ALL=%MSVS_INSTALL_ROOT_32% 12.0\VC\vcvarsall.bat
if "%MSVS_VERSION%" equ "2015" set VC_VARS_ALL=%MSVS_INSTALL_ROOT_32% 14.0\VC\vcvarsall.bat
if "%MSVS_VERSION%" equ "2017" call :vc_vars_all_lookup
if "%MSVS_VERSION%" equ "2019" call :vc_vars_all_lookup
if "%MSVS_VERSION%" equ "2022" call :vc_vars_all_lookup

if not exist "%VC_VARS_ALL%" goto not_found

if "%MSVC_VERSION%" equ "" set VCVARS_OPTS=
if "%MSVC_VERSION%" neq "" set VCVARS_OPTS=-vcvars_ver=%MSVC_VERSION%

call "%VC_VARS_ALL%" %MY_ARCH% %WINSDK_PLATFORM% %VCVARS_OPTS%

rem This approach avoids dos stripping things like a=b from input arguments, but it does rely on a 9 character "<version> <arch> " string preceeding the rest of the args.
set FULL_ARG_LINE=%*
%FULL_ARG_LINE:~9%

rem If the above is problematic the following can be used but it will need a=b arguments to be surrounded by double quotes and limits the number of arguments.
REM %3 %4 %5 %6 %7 %8 %9

endlocal

exit /B %ERRORLEVEL%

:vc_vars_all_lookup

if exist "%MSVS_INSTALL_ROOT_64%\%MSVS_VERSION%\BuildTools" set VC_VARS_ALL=%MSVS_INSTALL_ROOT_64%\%MSVS_VERSION%\BuildTools\VC\Auxiliary\Build\vcvarsall.bat
if exist "%MSVS_INSTALL_ROOT_64%\%MSVS_VERSION%\Professional" set VC_VARS_ALL=%MSVS_INSTALL_ROOT_64%\%MSVS_VERSION%\Professional\VC\Auxiliary\Build\vcvarsall.bat
if exist "%MSVS_INSTALL_ROOT_64%\%MSVS_VERSION%\Enterprise" set VC_VARS_ALL=%MSVS_INSTALL_ROOT_64%\%MSVS_VERSION%\Enterprise\VC\Auxiliary\Build\vcvarsall.bat
if exist "%MSVS_INSTALL_ROOT_32%\%MSVS_VERSION%\BuildTools" set VC_VARS_ALL=%MSVS_INSTALL_ROOT_32%\%MSVS_VERSION%\BuildTools\VC\Auxiliary\Build\vcvarsall.bat
if exist "%MSVS_INSTALL_ROOT_32%\%MSVS_VERSION%\Professional" set VC_VARS_ALL=%MSVS_INSTALL_ROOT_32%\%MSVS_VERSION%\Professional\VC\Auxiliary\Build\vcvarsall.bat
if exist "%MSVS_INSTALL_ROOT_32%\%MSVS_VERSION%\Enterprise" set VC_VARS_ALL=%MSVS_INSTALL_ROOT_32%\%MSVS_VERSION%\Enterprise\VC\Auxiliary\Build\vcvarsall.bat

exit /B 0


:not_found

echo "Unable to find vcvarsall.bat for version %MSVS_VERSION%"
exit /B 1


:usage

echo "Usage: <visual-studio-version> <architecture>"
exit /B 1

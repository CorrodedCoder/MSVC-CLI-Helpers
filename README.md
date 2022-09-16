# MSVC-CLI-Helpers
Scripts to aid MSVC tasks on the command line

# msvcenv.bat
This might be useful for anyone using the Visual Studio command line (well, technically Visual C++) who doesn’t want to have to open one command prompt per version of Visual Studio they want to use.

Let’s say you want to one line compile a simple program with multiple versions of Visual Studio and for multiple architectures and swap back and forth between them. As it stands you would need to open one Visual Studio command prompt for every version/architecture you wanted to use. With the following script you no longer need to do so.

## Usage
Usage is to pass in two required parameters followed by the commands you want to execute under that Visual Studio command line environment:
1. Visual Studio Version: 2008, 2010, 2012, 2013, 2015, 2017, 2019, 2022
2. Architecture: x86, x64
3. Command line and arguments you want to execute in this environment.

## Examples
### Compile same code with many versions of Visual Studio and different architectures
An example to compile a single file (test.cpp) into an executable (test) would be:  
`msvcenv.bat <visual-studio-version> <architecture> cl test.cpp -EHsc -Fe:test`  

Here is an example set of compiles for all supported platforms/architectures:  
```
msvcenv.bat 2008 x86 cl test.cpp -EHsc -Fe:test_x86_2008
msvcenv.bat 2008 x64 cl test.cpp -EHsc -Fe:test_x64_2008
msvcenv.bat 2010 x86 cl test.cpp -EHsc -Fe:test_x86_2010
msvcenv.bat 2010 x64 cl test.cpp -EHsc -Fe:test_x64_2010
msvcenv.bat 2012 x86 cl test.cpp -EHsc -Fe:test_x86_2012
msvcenv.bat 2012 x64 cl test.cpp -EHsc -Fe:test_x64_2012
msvcenv.bat 2013 x86 cl test.cpp -EHsc -Fe:test_x86_2013
msvcenv.bat 2013 x64 cl test.cpp -EHsc -Fe:test_x64_2013
msvcenv.bat 2015 x86 cl test.cpp -EHsc -Fe:test_x86_2015
msvcenv.bat 2015 x64 cl test.cpp -EHsc -Fe:test_x64_2015
msvcenv.bat 2017 x86 cl test.cpp -EHsc -Fe:test_x86_2017
msvcenv.bat 2017 x64 cl test.cpp -EHsc -Fe:test_x64_2017
msvcenv.bat 2019 x86 cl test.cpp -EHsc -Fe:test_x86_2019
msvcenv.bat 2019 x64 cl test.cpp -EHsc -Fe:test_x64_2019
msvcenv.bat 2022 x86 cl test.cpp -EHsc -Fe:test_x86_2022
msvcenv.bat 2022 x64 cl test.cpp -EHsc -Fe:test_x64_2022`  
```

### Use one environment then another
To switch to different environments and then return, simply specify “cmd”:  
`msvcenv.bat <visual-studio-version> <architecture> cmd`  

Here is an example set of compiles for all supported platforms/architectures:
```
C:\>msvcenv.bat 2019 x64 cmd
C:\>cl
Microsoft (R) C/C++ Optimizing Compiler Version 19.29.30146 for x64
Copyright (C) Microsoft Corporation.  All rights reserved.
usage: cl [ option... ] filename... [ /link linkoption... ]
C:\>exit

C:\>msvcenv.bat 2017 x86 cmd
**********************************************************************
** Visual Studio 2017 Developer Command Prompt v15.0
** Copyright (c) 2017 Microsoft Corporation
**********************************************************************
[vcvarsall.bat] Environment initialized for: 'x86'
Microsoft Windows [Version 10.0.19044.2006]
(c) Microsoft Corporation. All rights reserved.
C:\>cl
Microsoft (R) C/C++ Optimizing Compiler Version 19.16.27048 for x86
Copyright (C) Microsoft Corporation.  All rights reserved.
usage: cl [ option... ] filename... [ /link linkoption... ]
C:\>exit

C:\>msvcenv.bat 2015 x86 cmd
Microsoft Windows [Version 10.0.19044.2006]
(c) Microsoft Corporation. All rights reserved.
C:\>cl
Microsoft (R) C/C++ Optimizing Compiler Version 19.00.24245 for x86
Copyright (C) Microsoft Corporation.  All rights reserved.
usage: cl [ option... ] filename... [ /link linkoption... ]
C:\>exit
```

### Build using Meson
```
msvcenv.bat 2022 x86 meson setup --buildtype=debug vs2022_x86_debug
msvcenv.bat 2022 x86 meson compile -C vs2022_x86_debug
msvcenv.bat 2012 x64 meson setup --buildtype=debug vs2012_x64_debug
msvcenv.bat 2012 x64 meson compile -C vs2012_x64_debug
```

## Advanced Features
### Specify your choice of Windows Platform SDK (2015+)
By setting the environment variable WINSDK_PLATFORM prior to running the script you can configure your choice of which version of the SDK you wish to use. For example to chose the SDK to match the original release of Windows 10 (if installed!):  
```
C:\set WINSDK_PLATFORM=10.0.10240.0
C:\msvcenv.bat 2019 x86 cmd
```

### Specify your choice of toolchain (VS2017+)
Well, this is a bit of a strange one introduced with later versions of Visual Studio but effectively you’re using later tooling environment but compiling with an older standard of the SDK e.g. using a Visual Studio 2022 project but building using VS2015 as the compiler/linker (this can be set in the IDE too).

You achieve this by setting the environment variable MSVC_VERSION prior to running the script. If you set a version later than can be supported by that environment or specify a version of Visual Studio which does not support this, you’ll get some wacky syntax errors.

The current versions are:
* 2015: 14.0
* 2017: 14.1
* 2019: 14.2
* 2022: 14.3

Use Visual Studio 2017 environment but with the Visual Studio 2015 toolchain:
```
C:\set MSVC_VERSION=14.0
C:\msvcenv.bat 2017 x86 cmd
```

Use Visual Studio 2019 environment but with the Visual Studio 2017 toolchain:
```
C:\set MSVC_VERSION=14.1
C:\msvcenv.bat 2019 x86 cmd
```

Use Visual Studio 2022 environment but with the Visual Studio 2019 toolchain:
```
C:\set MSVC_VERSION=14.2
C:\msvcenv.bat 2022 x86 cmd
```

Use Visual Studio 2022 environment but with the Visual Studio 2015 toolchain
```
C:\set MSVC_VERSION=14.0
C:\msvcenv.bat 2022 x86 cmd
```

Use Visual Studio 2022 environment and with the Visual Studio 2022 toolchain (this is a pointless exercise!):
```
C:\set MSVC_VERSION=14.3
C:\msvcenv.bat 2022 x86 cmd
```

### Specify an alternate root for your install of Visual Studio
In case Visual Studio has not been installed in its default location, the root path can be specified using the environment variable MSVS_INSTALL_ROOT to the path string up to and including “Microsoft Visual Studio”.

For example:  
`set MSVS_INSTALL_ROOT=D:\Program Files (x86)\Microsoft Visual Studio`  
Or:  
`set MSVS_INSTALL_ROOT=D:\Program Files\Microsoft Visual Studio`  

# msvcwarn.py
A python 2/3 script to summarize the warning output piped to it from a Microsoft Visual C++ compilation, into a table of warning, count, and an example of warning text. This is useful if, for example, you wish to increase the warning level of a large body of code but don't necessarily want to go line by line through the output (yet).

Example output:
```
4100: count=2, example="'argc' : unreferenced formal parameter"
4350: count=1, example="behavior change: 'std::_Wrap_alloc<_Alloc>::_Wrap_alloc(const std::_Wrap_alloc<_Alloc> &) throw()' called instead of 'std::_Wrap_alloc<_Alloc>::_Wrap_alloc<std::_Wrap_alloc<_Alloc>>(_Other &) throw()'"
4530: count=1, example="C++ exception handler used, but unwind semantics are not enabled. Specify /EHsc"
4668: count=1, example="'NTDDI_WIN7SP1' is not defined as a preprocessor macro, replacing with '0' for '#if/#elif'"
4820: count=1070, example="'tagIMEMENUITEMINFOW' : '4' bytes padding added after data member 'tagIMEMENUITEMINFOW::szString'"
```

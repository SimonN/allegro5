@echo off

rem Sets up the Allegro package for building with the specified compiler,
rem and if possible converting text files from LF to CR/LF format.

rem Test if there are too many args.
if [%4] == []        goto arg3
goto help

:arg3
rem Test if third arg is ok.
if [%3] == [--quick]     goto arg2
if [%3] == [--msvcpaths] goto arg2
if [%3] == []            goto arg2
goto help

:arg2
rem Test if second arg is ok.
if [%2] == [--quick]     goto arg1
if [%2] == [--msvcpaths] goto arg1
if [%2] == []            goto arg1
goto help

:arg1
rem Test if first arg is ok.
if [%1] == [bcc32]   goto head
if [%1] == [djgpp]   goto head
if [%1] == [mingw32] goto head
if [%1] == [msvc]    goto head
if [%1] == [msvc7]   goto head
if [%1] == [icl]     goto head
if [%1] == [watcom]  goto head
goto help


:head
rem Generate header of makefile and alplatf.h,
rem then go to platform specific function.
echo # generated by fix.bat > makefile
echo /* generated by fix.bat */ > include\allegro\platform\alplatf.h

if [%1] == [bcc32]   goto bcc32
if [%1] == [djgpp]   goto djgpp
if [%1] == [mingw32] goto mingw32
if [%1] == [msvc]    goto msvc6
if [%1] == [msvc7]   goto msvc7
if [%1] == [icl]     goto icl
if [%1] == [watcom]  goto watcom

echo fix.bat internal error: not reached
goto help

:bcc32
echo Configuring Allegro for Windows/BCC32...
echo MAKEFILE_INC = makefile.bcc >> makefile
echo #define ALLEGRO_BCC32 >> include\allegro\platform\alplatf.h
goto tail

:djgpp
echo Configuring Allegro for DOS/djgpp...
echo MAKEFILE_INC = makefile.dj >> makefile
echo #define ALLEGRO_DJGPP >> include\allegro\platform\alplatf.h
goto tail

:mingw32
echo Configuring Allegro for Windows/Mingw32...
echo MAKEFILE_INC = makefile.mgw >> makefile
echo #define ALLEGRO_MINGW32 >> include\allegro\platform\alplatf.h
goto tail

:icl
echo Configuring Allegro for Windows/ICL...
echo COMPILER_ICL = 1 >> makefile
goto msvccommon

:msvc7
echo Configuring Allegro for Windows/MSVC7...
echo COMPILER_MSVC7 = 1 >> makefile
goto msvccommon

:msvc6
echo Configuring Allegro for Windows/MSVC6...
goto msvccommon

:msvccommon
echo MAKEFILE_INC = makefile.vc >> makefile
echo #define ALLEGRO_MSVC >> include\allegro\platform\alplatf.h
goto tail

:watcom
echo Configuring Allegro for DOS/Watcom...
echo MAKEFILE_INC = makefile.wat >> makefile
echo #define ALLEGRO_WATCOM >> include\allegro\platform\alplatf.h
goto tail

:help
echo.
echo Usage: fix platform [--quick] [--msvcpaths]
echo.
echo Where platform is one of: bcc32, djgpp, mingw32, msvc, msvc7, icl or watcom.
echo.
echo The --quick parameter is used to turn off LF to CR/LF conversion.
echo.
echo Use the --msvcpaths parameter if your MSVCDir variable contains 
echo spaces (you can view content of that variable by typing 
echo echo %%MSVCDir%%
echo on the command line). Remember that this will only work if you
echo have MinGW gcc in your PATH.
echo.
goto end

:convertmsvcdir
echo Converting MSVCDir path...
gcc -s -o msvchelp.exe misc/msvchelp.c
msvchelp MSVCDir
del msvchelp.exe
echo include makefile.helper >> makefile
goto realtail

:tail

if [%3] == [--msvcpaths] goto convertmsvcdir
if [%2] == [--msvcpaths] goto convertmsvcdir

:realtail
rem Generate last line of makefile and optionally convert CR/LF.
echo include makefile.all >> makefile

if [%2] == [--quick] goto done
if [%3] == [--quick] goto done
if [%1] == [bcc32]   goto done
if [%1] == [mingw32] goto done
if [%1] == [msvc]    goto done
if [%1] == [msvc7]   goto done

echo Converting Allegro files to DOS CR/LF format...
utod .../*.bat .../*.sh .../*.c *.cfg .../*.h .../*.inc .../*.rc
utod .../*.rh .../*.inl .../*.s .../*.txt .../*._tx makefile.*

:done
echo Done!

:end

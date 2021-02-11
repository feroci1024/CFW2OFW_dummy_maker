@echo off
setlocal enabledelayedexpansion

Set /P NAME="Enter Game folder(NPUB/NPEB/NPJB/ETC): "
mkdir "OUTPUT\%NAME%"

:: Hace lista de archivos
dir /b /s /a:-d "%NAME%\USRDIR\">list.txt

type list.txt | findstr /i /v ".sdat EBOOT.BIN" > temp.txt
del list.txt
rename temp.txt list.txt

Set infile=list.txt
Set find=%CD%\%NAME%\
Set replace=

for /F "tokens=*" %%n in (!infile!) do (
set LINE=%%n
set TMPR=!LINE:%find%=%replace%!
Echo !TMPR!>>TMP.TXT
)
move TMP.TXT %infile%

:: Preparar entorno y encriptar archivos
@echo on
mkdir "TEMP"
for /f "tokens=*" %%B in (!infile!) do mkdir "TEMP\%%~B"
for /f "tokens=*" %%B in (!infile!) do rmdir /Q "TEMP\%%~B"
for /f "tokens=*" %%B in (!infile!) do DummyCMD    "TEMP\%%~B"    1024    0
xcopy /E /I "TEMP\*.*" "OUTPUT\%NAME%\*.*"
for /f "tokens=*" %%B in (!infile!) do make_npdata -e "TEMP\%%~B" "OUTPUT\%NAME%\%%~B" 0 1 3 0 16
@echo off
del /f %infile%
rmdir /s /q "TEMP"


echo ===============================================================================
echo                                    END 
echo ===============================================================================

PAUSE

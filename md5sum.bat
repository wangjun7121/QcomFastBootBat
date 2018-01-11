@echo off
echo ************************
echo   Start check . . .
echo ************************

path=%cd%

if not exist "%path%\md5sum.exe" (
echo %path%\md5sum.exe is not found!
goto end
)

if not exist "%path%\checklist.md5" (
echo %path%\checklist.md5 is not found!
goto end
)

md5sum.exe -c checklist.md5

:end
echo ************************
echo   Done.
echo ************************

pause
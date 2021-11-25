@echo off
set NOPAUSE=true
rem set SKIP_WEATHER=true
call build.cmd
copy build\*.miz .
pause
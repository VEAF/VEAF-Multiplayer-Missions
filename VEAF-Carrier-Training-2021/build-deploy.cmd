@echo off
set NOPAUSE=true
set SKIP_WEATHER=true
call build.cmd
copy build\*.miz .
pause
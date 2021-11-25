@echo off
set NOPAUSE=true
set VERBOSE_LOG_FLAG=true
rem set LUA_SCRIPTS_DEBUG_PARAMETER=-debug
set SECURITY_DISABLED_FLAG=true
set DYNAMIC_SCRIPTS_PATH="d:\dev\_VEAF\VEAF-Mission-Creation-Tools"
set DYNAMIC_LOAD_SCRIPTS=true
set SKIP_WEATHER=true
call build.cmd
copy build\*.miz .
pause
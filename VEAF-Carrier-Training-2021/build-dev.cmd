@echo off
set NOPAUSE=true
rem set VERBOSE_LOG_FLAG=true
rem set LUA_SCRIPTS_DEBUG_PARAMETER=-trace
rem set SECURITY_DISABLED_FLAG=true
set DYNAMIC_SCRIPTS_PATH="d:\dev\_VEAF\VEAF-Mission-Creation-Tools"
rem set DYNAMIC_LOAD_SCRIPTS=true
rem set SKIP_WEATHER=true
call build.cmd
copy build\*.miz .
pause
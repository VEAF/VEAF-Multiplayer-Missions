@echo off
set NOPAUSE=true
set VERBOSE_LOG_FLAG=true
rem set LUA_SCRIPTS_DEBUG_PARAMETER=-trace
rem set SECURITY_DISABLED_FLAG=true
set DYNAMIC_SCRIPTS_PATH_TRIGGER="C:/Users/veaf/Documents/VEAF-Mission-Tools"
set DYNAMIC_LOAD_SCRIPTS=true
set DYNAMIC_LOAD_MISSION=false
set SKIP_WEATHER=true
call build.cmd
copy build\*.miz .
pause
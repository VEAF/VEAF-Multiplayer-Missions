@echo off
FOR /D %%f IN (missions\*) DO (
	echo ----------------------------------------------
	echo ----------------------------------------------
	echo Building mission %%~nxf
	echo ----------------------------------------------
	echo ----------------------------------------------
	set SKIP_WEATHER=true
	set NOPAUSE=true
	call build_mission.cmd %%~nxf
	copy build\*.miz .
	set NPM_UPDATE=false
)
pause

FOR /D %%f IN (VEAF-Carrier-Training-2021, VEAF-Light-Training-2021, VEAF-Missile-Training) DO (
	pushd %%f
	set NOPAUSE=true
	set VERBOSE_LOG_FLAG=
	set LUA_SCRIPTS_DEBUG_PARAMETER=
	set SECURITY_DISABLED_FLAG=
	set SEVENZIP=
	set LUA=
	set DYNAMIC_MISSION_PATH=
	set DYNAMIC_SCRIPTS_PATH=
	set NPM_UPDATE=
	set MISSION_FILE_SUFFIX1=
	set TIMEBUILD=
	set MISSION_FILE_SUFFIX2=
	set MISSION_FILE=
	call build.cmd
	copy build\*.miz ..\
	popd
)

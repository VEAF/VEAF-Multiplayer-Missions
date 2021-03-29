set NOPAUSE=true
FOR /D %%f IN (*) DO (
	pushd %%f
	call build.cmd
	copy build\*.miz ..\
	popd
)
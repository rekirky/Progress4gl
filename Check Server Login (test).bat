@echo off
call:menu



:menu
set /p option="Check Server - [1], Remove User - [2], Check dev01 - [3]: "
if /i "%option%"=="1" call:check
if /i "%option%"=="2" call:remove
if /i "%option%"=="3" call:dev01

:check
set /p name="Enter Server: "
qwinsta /server:%name%
call:rerun

:remove
set /p name="Enter Server: "
qwinsta /server:%name%
set /p user="Enter ID #: "
rwinsta /server:%name% %user%
call:rerun
exit

:dev01
qwinsta /server:dev01
call:rerun



:rerun
set /p var=Run Again? [Y/N]?:
if /i "%var%"=="y" call:menu
exit
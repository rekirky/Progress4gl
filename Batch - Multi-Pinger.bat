@echo off
call:pinger




:pinger
set /p ip="Enter IP address: "
set /p num="Enter number of pings: "
ping %ip% -n %num%
pause
call:repeat


:repeat
set /p var=Run again?[Y/N]: 
if /i "%var%"=="y" goto :pinger
if /i "%var%" =="n" exit

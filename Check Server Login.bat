@echo off
set /p name="Enter Server: "

qwinsta /server:%name%
pause
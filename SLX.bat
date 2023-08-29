@echo off
call:slx

:slx
cd "C:\Program Files (x86)\Microsoft Office\root\Office16"
ren  OLMAPI32.DLL OLMAPI32(1).DLL
cd "C:\Program Files (x86)\Saleslogix"
start Saleslogix.exe
timeout /t 1 /nobreak
cd "C:\Program Files (x86)\Microsoft Office\root\Office16"
ren  OLMAPI32(1).DLL OLMAPI32.DLL
goto:eof

:eof

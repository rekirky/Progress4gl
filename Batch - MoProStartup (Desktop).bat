@echo off
call:entry
pause
exit


:entry
set /p var=Launch MoPro Programs?[Y/N]: 
set /p var2=Whatsapp?[Y/N]: 

if /i "%var%"=="y" call:mopro
if /i "%var%"=="n" echo do not load mopro 
if /i "%var2%"=="y" call:whatsapp
if /i "%var2%"=="n" echo do not load whatsapp
exit




:mopro
cd "C:\Program Files (x86)\Microsoft Office\root\Office16"
start outlook.exe
start lync.exe
cd "C:\Program Files (x86)\Devolutions\Remote Desktop Manager Free"
start RemoteDesktopManagerFree.exe
goto:eof

:whatsapp
cd "C:\Users\jonathan.kirkwood\AppData\Local\WhatsApp"
start WhatsApp.exe
goto:eof


:eof
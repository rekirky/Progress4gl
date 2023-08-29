@echo off
call:entry
exit


:entry
set /p var=Launch MoPro Programs?[Y/N]: 
set /p var2=Spotify?[Y/N]: 

if /i "%var%"=="y" call:mopro
if /i "%var%"=="n" echo do not load mopro 
if /i "%var2%"=="y" call:spotify
if /i "%var2%"=="n" echo do not load spotify 
exit




:mopro
cd "C:\Program Files (x86)\Microsoft Office\Office15"
start outlook.exe
start lync.exe
cd "C:\Program Files (x86)\Saleslogix"
start Saleslogix.exe
cd "C:\Program Files (x86)\Devolutions\Remote Desktop Manager Free"
start RemoteDesktopManagerFree.exe
goto:eof

:spotify
cd "C:\Users\Jonathan.Kirkwood\AppData\Roaming\Spotify\"
start spotify.exe
goto:eof

:eof
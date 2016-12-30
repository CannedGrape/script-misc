REM Kill explorer
taskkill /f /im explorer.exe

REM Clean icon cache DB
attrib -h -s -r       "%userprofile%\AppData\Local\IconCache.db"
del    /f             "%userprofile%\AppData\Local\IconCache.db"

attrib /s /d -h -s -r "%userprofile%\AppData\Local\Microsoft\Windows\Explorer\*"
del    /f             "%userprofile%\AppData\Local\Microsoft\Windows\Explorer\thumbcache_*.db"

REM Clean Register
echo y |reg delete "HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" /v IconStreams
echo y |reg delete "HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" /v PastIconsStream

rem Restart explorer
start explorer

pause

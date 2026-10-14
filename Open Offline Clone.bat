@echo off
title landonorris.com offline clone
cd /d "%~dp0"

rem --- pick a free-ish port ---
set PORT=8100

rem If something is already serving on the port, just open the browser.
netstat -ano | findstr /r /c:":%PORT% .*LISTENING" >nul 2>&1
if %errorlevel%==0 goto openbrowser

echo Starting local server on http://127.0.0.1:%PORT%/ ...
start "clone-server" /min cmd /c "python -m http.server %PORT%"
rem give the server ~1s to come up
timeout /t 1 /nobreak >nul

:openbrowser
start "" "http://127.0.0.1:%PORT%/index.html"
exit /b 0

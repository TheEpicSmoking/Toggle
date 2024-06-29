@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0"
set "config=config.ini"
:: Window conf
title "Toggle"
mode con: cols=35 lines=7

:: ANSI Escape Sequence
set "ESC="
for /f %%A in ('echo prompt $E ^| cmd') do set "ESC=%%A"
set "GREEN=%ESC%[32m"
set "RESET=%ESC%[0m"
set "RED=%ESC%[31m"
set "YELLOW=%ESC%[33m"

:: Read devices from config.ini
set "count=0"
for /f "tokens=1,2 delims== " %%A in ('findstr /R "^device[0-9]*=" %config%') do (
    set /a count+=1
    set "device[!count!].name=%%A"
    set "device[!count!].id=%%B"
)
echo "%device[1].name%"
echo "%device[1].id%"
pause

:beginning

:: Verify Devices status
for /f "tokens=1,2 delims=," %%A in ('findstr /R  /C:"^device[0-9]*=" /G:config.ini') do (
    set "%%A_enabled=false"
    for /f "tokens=2 delims=," %%B in ("%%B") do (
        devcon status %%B | findstr "running." > nul
        if %errorlevel% equ 0 (
            set "%%A_enabled=true"
        )
    )
)

:: Main menu
call :StatusViewer
set /p choice=">  "

for /f "tokens=1,2 delims=," %%A in ('findstr /R  /C:"^device[0-9]*=" /G:config.ini'') do (
    if "%choice%" == "%%A" (
        if "%%A_enabled" == "false" (
            for /f "tokens=2 delims=," %%B in ("%%B") do (
                devcon enable %%B >nul
            )
        ) else (
            for /f "tokens=2 delims=," %%B in ("%%B") do (
                devcon disable %%B >nul
            )
        )
        goto :beginning
    )
)

if "%choice%" == "e" (
    call :enableAllDevices
) else if "%choice%" == "d" (
    call :disableAllDevices
) else if "%choice%" == "h" (
    cls
    echo|set /p="0-9  %YELLOW%|%RESET% Toggle Device."
    echo:
    echo|set /p=" e    %YELLOW%|%RESET% Enable all Devices."
    echo:
    echo|set /p=" d    %YELLOW%|%RESET% Disable all Devices."
    echo:
    echo|set /p=" r    %YELLOW%|%RESET% Refresh."
    echo:
    echo|set /p=" q    %YELLOW%|%RESET% Quit."
    echo:
    echo:
    echo|set /p="Press a button to return... "
    pause >nul
    goto :beginning
) else if "%choice%" == "r" (
    goto :beginning
) else if "%choice%" == "q" (
    endlocal
    exit
) else (
    cls
    call :StatusViewer
    echo|set /p="%RED%Invalid Choice.%RESET% Type '%YELLOW%h%RESET%' for help."
    echo:
    timeout /t 2 >nul
    goto :beginning
)

:enableAllDevices
for /f "tokens=1,2 delims=," %%A in ('findstr /R  /C:"^device[0-9]*=" /G:config.ini') do (
    for /f "tokens=2 delims=," %%B in ("%%B") do (
        devcon enable %%B >nul
    )
)
goto :beginning

:disableAllDevices
for /f "tokens=1,2 delims=," %%A in ('findstr /R  /C:"^device[0-9]*=" /G:config.ini') do (
    for /f "tokens=2 delims=," %%B in ("%%B") do (
        devcon disable %%B >nul
    )
)
goto :beginning

:StatusViewer
cls
echo %cd%
echo --------- DEVICES  STATUS ---------
for /f "tokens=1,2 delims=," %%A in ('findstr /R  /C:"^device[0-9]*=" /G:config.ini') do (
    if "%%A_enabled" == "true" (
        echo %%A. %%B: %GREEN%Enabled%RESET%
    ) else (
        echo %%A. %%B: %RED%Disabled%RESET%
    )
)
echo -----------------------------------
goto :eof
@echo off
setlocal enabledelayedexpansion

:: Set wd for confing.ini
cd /d "%~dp0"
set "config=config.ini"
mode con: cols=44 lines=7

:: ANSI Escape Sequence
set "ESC="
for /f %%A in ('echo prompt $E ^| cmd') do set "ESC=%%A"
set "GREEN=%ESC%[32m"
set "RESET=%ESC%[0m"
set "RED=%ESC%[31m"
set "YELLOW=%ESC%[33m"

:: Read devices from config.ini into an array
set "inDevicesSection=false"
set "count=0"
set "DeviceCount=0"
for /f "tokens=1,2 delims==" %%A in (%config%) do (
    if "%%A"=="[devices]" (
        set "inDevicesSection=true"
    ) else ( echo %%A | find "[" >nul
            if !errorlevel! equ 0 (
            set "inDevicesSection=false"
        )
    )
    if "!inDevicesSection!"=="true" if not "!count!"=="0" (
        set "deviceName=%%A"
        if "!deviceName:~30!" neq "" set "deviceName=!deviceName:~0,30!"
        set "device[!count!].name=!deviceName!"
        set "device[!count!].id=@%%B"
        set /a DeviceCount+=1
    )
    set /a count+=1
)

:: Window conf
title "Toggle"
set /a "num_lines=DeviceCount + 4"
if  %num_lines% leq 6 (set /a "num_lines=7")
mode con: cols=44 lines=%num_lines%

:beginning

:: Verify Devices status
for /L %%i in (1,1,!DeviceCount!) do (
    set "device[%%i].enabled=false"
    devcon status "!device[%%i].id!" | findstr "running." > nul
    if !errorlevel! equ 0 (
        set "device[%%i].enabled=true"
    )
)

:: Main menu

call :StatusViewer
set /p choice=">  "

if %choice% gtr 0 if %choice% leq %devicecount% (
    if "!device[%choice%].enabled!" == "false" (
        devcon enable "!device[%choice%].id!" >nul
    ) else (
        devcon disable "!device[%choice%].id!" >nul
    )
    goto :beginning
) else if "%choice%" == "e" (
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
for /L %%i in (1,1,!DeviceCount!) do (
    devcon enable "!device[%%i].id!" >nul
)
goto :beginning

:disableAllDevices
for /L %%i in (1,1,!DeviceCount!) do (
    devcon disable "!device[%%i].id!" >nul
)
goto :beginning

:StatusViewer
cls
echo -------------- DEVICES STATUS --------------
for /L %%i in (1,1,!DeviceCount!) do (
    if "!device[%%i].enabled!" == "true" (
        echo %%i. !device[%%i].name!: %GREEN%Enabled%RESET%
    ) else if "!device[%%i].enabled!" == "false" (
        echo %%i. !device[%%i].name!: %RED%Disabled%RESET%
    )
)
echo --------------------------------------------
goto :eof
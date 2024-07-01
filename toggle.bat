@echo off
setlocal enabledelayedexpansion

:: Set directory and loading screen
cd /d "%~dp0"
mode con: cols=45 lines=7
:refresh
echo|set /p="Loading devices..." 

:: Read from config.ini
set "DeviceCount=0"
for /f "tokens=1,2 delims==" %%A in (config.ini) do (
    if "%%A"=="[settings]" (
    set "inSettingsSection=true"
    ) else ( echo %%A | find "[" >nul
            if !errorlevel! equ 0 set "inSettingsSection=false"
    )
    if "%%A"=="[devices]" (
        set "inDevicesSection=true"
    ) else ( echo %%A | find "[" >nul
            if !errorlevel! equ 0 set "inDevicesSection=false"
    )

        :: Read settings
    if "!inSettingsSection!"=="true" if not "%%A"=="[settings]" (
        if "%%A"=="adaptive_height" set "adaptive_height=%%B"
        if "%%A"=="frame" set "frame=%%B"
        if "%%A"=="colors" set "colors=%%B"
        if "%%A"=="columns" set "columns=%%B"
        if "%%A"=="lines" set "lines=%%B"
    )

    :: Read devices into an array
    if "!inDevicesSection!"=="true" if not "%%A"=="[devices]" (
        set /a DeviceCount+=1
        set "device[!DeviceCount!].name=%%A"
        set "device[!DeviceCount!].id=@%%B"
    )
)
:: Window conf
title "WinDev Switch"
set /a "max_name_length=columns - 15"
if "%adaptive_height%" == "true" (
    set /a "lines=DeviceCount + 2"
    if "%frame%"=="true" set /a "lines=lines + 2"
)
    if  %lines% leq 4 (set /a "lines=5")
    if  %columns% leq 15 (set /a "columns=16")
mode con: cols=%columns% lines=%lines%

:: ANSI Escape Sequence
set "ESC="
for /f %%A in ('echo prompt $E ^| cmd') do set "ESC=%%A"
if "%colors%"=="true" (
    set "GREEN=%ESC%[32m"
    set "RESET=%ESC%[0m"
    set "RED=%ESC%[31m"
    set "YELLOW=%ESC%[33m"
) else (
    set "GREEN="
    set "RESET="
    set "RED="
    set "YELLOW="
)

:menu

:: Verify Devices status
for /L %%i in (1,1,!DeviceCount!) do (
    set "device[%%i].enabled=false"
    devcon status "!device[%%i].id!" | findstr "running." > nul
    if !errorlevel! equ 0 set "device[%%i].enabled=true"
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
    goto :menu
) else if "%choice%" == "e" (
    call :enableAllDevices
) else if "%choice%" == "d" (
    call :disableAllDevices
) else if "%choice%" == "h" (
    call :helper
) else if "%choice%" == "r" (
    goto :refresh
) else if "%choice%" == "q" (
    endlocal
    exit
) else (
    cls
    call :StatusViewer
    echo|set /p="%RED%Invalid Choice.%RESET% Type '%YELLOW%h%RESET%' for help."
    echo:
    timeout /t 2 >nul
    goto :menu
)

:enableAllDevices
    for /L %%i in (1,1,!DeviceCount!) do (
        devcon enable "!device[%%i].id!" >nul
    )
goto :menu

:disableAllDevices
    for /L %%i in (1,1,!DeviceCount!) do (
        devcon disable "!device[%%i].id!" >nul
    )
goto :menu

:helper
    cls
    echo|set /p="[0-9]* %YELLOW%|%RESET% Toggle Device."
    echo:
    echo|set /p="e      %YELLOW%|%RESET% Enable all Devices."
    echo:
    echo|set /p="d      %YELLOW%|%RESET% Disable all Devices."
    echo:
    echo|set /p="r      %YELLOW%|%RESET% Refresh."
    echo:
    echo|set /p="q      %YELLOW%|%RESET% Quit."
    echo:
    echo:
    echo|set /p="Press a button to return... "
    pause >nul
goto :menu

::Visuals
:StatusViewer
    cls
    if "%frame%"=="true" call :titleline
    for /L %%i in (1,1,!DeviceCount!) do (
        if "!device[%%i].name:~%max_name_length%!" neq "" set "device[%%i].name=!device[%%i].name:~0,%max_name_length%!"
        if "!device[%%i].enabled!" == "true" (
            echo %%i. !device[%%i].name!: %GREEN%Enabled%RESET%
        ) else if "!device[%%i].enabled!" == "false" (
            echo %%i. !device[%%i].name!: %RED%Disabled%RESET%
        )
    )
    if "%frame%"=="true" call :bottomline
goto :eof

:bottomline
    set "line="
    for /L %%i in (1,1,!columns!) do (
        set "line=!line!-"
    )
    echo !line!
goto :eof

:titleline
    set "line="
    set /A "TitleSpacer=columns - 15"
    set /A "mod=columns %% 2"
    set /A "hcolumns=TitleSpacer/2"
    if %mod% == 0 (
        set "TitleText= WinDev  Switch "
    ) else (
        set "TitleText=- WinDev Switch "
    )

    for /L %%i in (1,1,!TitleSpacer!) do (
        if %%i == %hcolumns% (
            set "line=!line!%TitleText%"
        ) else (
            set "line=!line!-"
        )
    )
    echo !line!
goto :eof
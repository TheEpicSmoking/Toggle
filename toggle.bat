@echo off
setlocal

mode con: cols=35 lines=7

set "ESC="
for /f %%A in ('echo prompt $E ^| cmd') do set "ESC=%%A"
set "GREEN=%ESC%[32m"
set "RESET=%ESC%[0m"
set "RED=%ESC%[31m"

:: ID periferiche
set "touch_screen=@HID\WACF2200&COL01\4&34C53&1&0000"
set "pen=@HID\WACF2200&COL05\4&34C53&1&0004"
set "touch_pad=@HID\SYNAC780&COL02\4&3B228C5&1&0001"

:beginning

:: Verifica lo stato delle periferiche
set "ts_enabled=false"
set "pen_enabled=false"
set "tp_enabled=false"

devcon status "%touch_screen%" | findstr "running." > nul
if %errorlevel% equ 0 (
    set "ts_enabled=true"
)
devcon status "%touch_pad%" | findstr "running." > nul
if %errorlevel% equ 0 (
    set "tp_enabled=true"
)
devcon status "%pen%" | findstr "running." > nul
if %errorlevel% equ 0 (
    set "pen_enabled=true"
)

call :VisualizzaStato
echo:
set /p choice="Enable/Disable, h for 'help': "

if "%choice%" == "1" (
    if "%pen_enabled%" == "false" (
    devcon enable "%pen%" >nul
    ) else (
        devcon disable "%pen%" >nul
    )
    timeout /t 0.1 >nul
    goto :beginning
) else if "%choice%" == "2" (
    if "%ts_enabled%" == "false" (
    devcon enable "%touch_screen%" >nul
    ) else (
        devcon disable "%touch_screen%" >nul
    )
    timeout /t 0.1 >nul
    goto :beginning
) else if "%choice%" == "3" (
    if "%tp_enabled%" == "false" (
        devcon enable "%touch_pad%" >nul
    ) else (
        devcon disable "%touch_pad%" >nul
    )
    timeout /t 0.1 >nul
    goto :beginning
) else if "%choice%" == "e" (
    call :enableAllDevices
) else if "%choice%" == "d" (
    call :disableAllDevices
) else if "%choice%" == "h" (
    call :VisualizzaStato
    echo|set /p="1,2,3 | Toggle Device."
    echo:
    echo|set /p="e     | Enable all Devices."
    echo:
    echo|set /p="d     | Disable all Devices."
    echo:
    echo|set /p="r     | Refresh."
    echo:
    echo|set /p="q     | Quit."
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
    echo Scelta non valida. Riprova.
    timeout /t 0.1 >nul
    goto :beginning
)


:enableAllDevices
rem Funzione per abilitare tutti i dispositivi
devcon enable "%pen%" >nul
devcon enable "%touch_screen%" >nul
devcon enable "%touch_pad%" >nul
goto :beginning

:disableAllDevices
rem Funzione per disabilitare tutti i dispositivi
devcon disable "%pen%" >nul
devcon disable "%touch_screen%" >nul
devcon disable "%touch_pad%" >nul
goto :beginning

:: Mostra lo stato delle periferiche
:VisualizzaStato
cls
echo --- STATO DISPOSITIVI ---
if "%pen_enabled%" == "true" (
    echo 1. Pen: %GREEN%Enabled%RESET%
) else (
    echo 1. Pen: %RED%Disabled%RESET%
)
if "%ts_enabled%" == "true" (
    echo 2. Touch Screen: %GREEN%Enabled%RESET%
) else (
    echo 2. Touch Screen: %RED%Disabled%RESET%
)
if "%tp_enabled%" == "true" (
    echo 3. Touch Pad: %GREEN%Enabled%RESET%
) else (
    echo 3. Touch Pad: %RED%Disabled%RESET%
)
echo -------------------------
goto :eof
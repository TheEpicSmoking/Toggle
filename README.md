# WinDev Switch

## Overview

WinDev Switch is a batch script designed to manage device states (enabled/disabled) on a Windows machine using `devcon`. This script reads configurations from a `config.ini` file and provides an interactive menu for toggling device states.

## Features

- Displays a quick interactive menu for enabling/disabling devices.
- Allows enabling/disabling all devices at once.
- Configurable console window size.

## Usage

Place the script and `config.ini` in the same directory.
Run the script by double-clicking it or executing it in the command line:
```cmd
path\to\script\WinDevSwitch.bat
```

## Menu Options

- [0-9]*: Toggle the state of the corresponding device.
- e: Enable all devices.
- d: Disable all devices.
- r: Refresh the device list and reread config.ini to reflect any changes.
- h: Show help.
- q: Quit the script.

## Prerequisites

- `devcon` must be installed and accessible via the command line.
- `config.ini` must be present in the same directory as the script, with sections for `[settings]` and `[devices]`.

## Installing devcon

1. Download `devcon` from the Microsoft website or another trusted source.
2. Extract the `devcon` executable to a known directory, for example `C:\devcon`.
3. Add the directory to your system's PATH:
   - Open the Start Menu, type "Environment Variables," and select "Edit the system environment variables."
   - Click on "Environment Variables" in the System Properties window.
   - In the Environment Variables window, find and select the "Path" variable under System variables, and click "Edit."
   - Click "New" and add the path to the directory where `devcon` is located (e.g., `C:\devcon`).
   - Click "OK" to close all windows.

## Retrieving Device IDs

1. Open a Command Prompt with administrator privileges.
2. List all devices and their IDs using `devcon`:
   ```cmd
   devcon find *
   ```
3. Identify the devices you want to manage and note their IDs (e.g., `PCI\VEN_10EC&DEV_8136&SUBSYS_813610EC`).
4. Add these device names and IDs to the `[devices]` section of your `config.ini` file. Note that the device names can be whatever you want, but they must not contain equals (`=`).

## config.ini (Example)
```
[settings]
frame=true
colors=true
columns=45
lines=7
adaptive_height=true

[devices]
WiFi=PCI\VEN_10EC&DEV_8176&SUBSYS_817610EC
Bluetooth=USB\VID_0A12&PID_0001
Ethernet=PCI\VEN_10EC&DEV_8136&SUBSYS_813610E
```

## Settings

- `frame`: Decides if the menu has a frame around it.
- `colors`: Enables or disables colored output (green for enabled, red for disabled).
- `columns`: Sets the console window width.
- `lines`: Sets the console window height (only works if `adaptive_height` is `false`).
- `adaptive_height`: Dynamically changes the console window height based on the number of devices.

## Notes
- Ensure devcon is properly installed and the device IDs in config.ini are correct.
- Running the script may require administrator privileges for enabling/disabling devices.
- An icon is provided if you want to use it!
- This project is licensed under the GPL License.

Enjoy managing your devices with WinDev Switch!

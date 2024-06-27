# Toggle Device Script

This is a Windows batch script that toggles the status of specific input devices (Pen, Touch Screen, and Touch Pad) using the DevCon command-line utility.

## Features

- Enable or disable individual devices.
- Enable all devices at once.
- Disable all devices at once.
- Refresh device status.
- View help instructions.

## Prerequisites

- **DevCon Utility**: This script requires the DevCon command-line utility to manage device states. You can download DevCon from the Microsoft website.

## Devices

The script is configured to manage the following devices:
- **Pen**: `@HID\WACF2200&COL05\4&34C53&1&0004`
- **Touch Screen**: `@HID\WACF2200&COL01\4&34C53&1&0000`
- **Touch Pad**: `@HID\SYNAC780&COL02\4&3B228C5&1&0001`

You can modify these device IDs in the script to manage other devices as needed.

## Usage

1. **Download DevCon Utility** and place it in the same directory as the script or add it to your system's PATH.
2. **Run the script** by double-clicking `ToggleDevices.bat` or running it from the command line.

### Main Menu

- `0-9`: Toggle specific device.
- `e`: Enable all devices.
- `d`: Disable all devices.
- `r`: Refresh status.
- `q`: Quit.

## Code Explanation

The script performs the following steps:

1. **Set up window configuration**: Sets the window title and size.
2. **Define ANSI escape sequences**: For colored text output.
3. **Identify devices**: Sets the device IDs for Pen, Touch Screen, and Touch Pad.
4. **Check device status**: Uses `devcon status` to determine if each device is running.
5. **Display main menu**: Shows the status of each device and waits for user input.
6. **Handle user input**: Based on the input, it enables/disables devices, shows help, refreshes status, or exits the script.

## Notes

- Ensure that DevCon is properly installed and accessible from the script.
- Modify device IDs in the script if necessary to match your specific hardware.
- Run the script with administrative privileges (`Run as Administrator`) for proper operation.

## License

This project is licensed under the MIT License.

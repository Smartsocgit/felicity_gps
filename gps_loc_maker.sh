#!/bin/bash

# Define the path to the shell script

# Create the 'scripts' directory if it doesn't exist
mkdir -p /opt/aikaan/scripts

SHELL_SCRIPT_PATH="/opt/aikaan/scripts/gps-location.sh"

# Create the shell script with the initial content
cat << EOF > $SHELL_SCRIPT_PATH
#!/bin/sh
echo lat=00.000000
echo lon=00.000000
EOF

# Make the shell script executable and give read and write permissions
chmod 766 $SHELL_SCRIPT_PATH

# Create a udev rule to grant permanent permissions to /dev/ttyUSB*
UDEV_RULE_PATH="/etc/udev/rules.d/99-usb-permissions.rules"

# Write the udev rule to the file
cat << EOF > $UDEV_RULE_PATH
# Grant read/write permissions to all /dev/ttyUSB* devices
KERNEL=="ttyUSB[0-9]*", MODE="0666", GROUP="dialout"
EOF

# Reload udev rules and trigger changes
udevadm control --reload
udevadm trigger

# Confirm the actions taken
echo "Shell script created at $SHELL_SCRIPT_PATH and made executable."
echo "Udev rule created at $UDEV_RULE_PATH to grant permissions for /dev/ttyUSB*."

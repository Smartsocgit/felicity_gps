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

# Confirm the script has been created and made executable
echo "Shell script created and set as executable and readable/writable at $SHELL_SCRIPT_PATH"

#!/bin/bash

# Define variables
SERVICE_NAME="gps_loc_service"
USER_HOME=$(eval echo ~${SUDO_USER}) # Get the home directory of the non-root user
DIRECTORY="${USER_HOME}/felicity_gps"
PYTHON_SCRIPT="${DIRECTORY}/gps_loc.py"
GPS_LOCATION_MAKER="${DIRECTORY}/gps_loc_maker.sh"
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"
NON_ROOT_USER=${SUDO_USER} # Get the non-root user invoking the script

# Step 1: Install necessary packages and Python dependencies
echo "Installing python3-pip and pyserial..."
sudo apt install -y python3-pip
pip3 install pyserial

# Step 2: Set permissions for USB ports
echo "Setting permissions for all USB ports..."
sudo chmod 666 /dev/ttyUSB*

# Step 3: Make sure gps_loc_maker.sh is executable and execute it
echo "Setting execute permissions for gps_loc_maker.sh..."
chmod +x "${GPS_LOCATION_MAKER}"

echo "Executing gps_loc_maker.sh..."
sudo "${GPS_LOCATION_MAKER}"

# Step 4: Create the systemd service file
echo "Creating systemd service file..."
sudo bash -c "cat << EOF > ${SERVICE_FILE}
[Unit]
Description=GPS Location Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 ${PYTHON_SCRIPT}
Restart=on-failure
User=${NON_ROOT_USER}
WorkingDirectory=${DIRECTORY}

[Install]
WantedBy=multi-user.target
EOF"

# Step 5: Set proper permissions for the service file
echo "Setting permissions for the service file..."
sudo chmod 644 "${SERVICE_FILE}"

# Step 6: Enable and start the service
echo "Enabling and starting the service..."
sudo systemctl daemon-reload
sudo systemctl enable "${SERVICE_NAME}"
sudo systemctl start "${SERVICE_NAME}"

echo "Service setup complete. Check the service status using: sudo systemctl status ${SERVICE_NAME}"

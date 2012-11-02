# Alias for downloading GPS data from the Holux via Bluetooth.
# Saves to 'data.bin' and 'data.gpx' in the current directory.
alias gpsdl="gpsbabel -tw -i m241 -f /dev/cu.HOLUX_M-241-SPPSlave -o gpx -F data.gpx"

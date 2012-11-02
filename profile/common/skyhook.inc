# Use the Skyhook system to determine the geographical position of a wireless access point using its MAC address.

alias pos=position
alias position=skyhookposition
function skyhookposition(){
  if [ ! -z "$1" ]; then
    macaddress=$1
    curl --header "Content-Type: text/xml" --data "<?xml version='1.0'?><LocationRQ xmlns='http://skyhookwireless.com/wps/2005' version='2.6' street-address-lookup='full'><authentication version='2.0'><simple><username>beta</username><realm>js.loki.com</realm></simple></authentication><access-point><mac>${macaddress}</mac><signal-strength>-50</signal-strength></access-point></LocationRQ>" https://api.skyhookwireless.com/wps2/location
  else
    echo "Supply a valid MAC address in the form AABBCCDDEEFF.";
  fi
}

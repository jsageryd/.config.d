# eject ev. skiva om inget argument, annars eject [namn från /Volumes/] eller eject [namn från /dev/]
eject(){
  vol=/Volumes
  dev=/dev
  device="${1%/}"
  if [ ! -z "${1}" ]; then
    if [ ! -e "${device}" ]; then
      device="${vol}/${1}";
    fi
    if [ ! -e "${device}" ]; then
      device="${dev}/${1}";
    fi
    if [ ! -e "${device}" ]; then
      echo "Device does not exist";
    else
      echo "${device}";
      diskutil eject "${device}";
    fi
  else
    echo "No argument";
  fi
}

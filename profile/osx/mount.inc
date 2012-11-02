# Mounts devices
mount_all(){
  for ((i=1;i<5;i++))
  do
    diskutil mountDisk disk${i} > /dev/null 2>&1
  done
}

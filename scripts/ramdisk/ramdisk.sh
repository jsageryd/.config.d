#!/usr/bin/env sh

# Creates a ramdisk on OS X

size=$1

if [ -z $size ]; then
  echo 'Usage: ramdisk <size in gb>; e.g. ramdisk 2 to create a 2 GB ramdisk'
  exit 1
fi

mb=$(($size * 1024))
blocks=$(($mb * 2048))

diskutil erasevolume APFS "ramdisk_$mb" `hdiutil attach -nomount ram://$blocks`

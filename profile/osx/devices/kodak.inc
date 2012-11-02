# Kodak EASYSHARE S730 Digital Frame; ffmpeg video encoding
# Source video is assumed to be 16:9

# Size              800x480 (830x480 without cropping)
# Crop left         15 px
# Crop right        15 px
# Video bitrate     1250 kbit/s
# Audio bitrate     64 kbit/s
# Video codec       MPEG-4 part 2 (like XviD)
# Audio codec       MP3

function kodak() {
  ffmpeg -i ${1} -s 830x480 -b 1250k -ab 64k -cropleft 15 -cropright 15 -vcodec mpeg4 -acodec libmp3lame ${1%.*}_S730.avi
}

#!/bin/sh

# This script uploads the given file(s) to x0.at and prints the returned URL(s).

if test -z "$1"; then
  echo 'Usage: x0 <file> [<file> ...]'
  exit 1
fi

for file in "$@"; do
  if test ! -f "$file"; then
    printf 'Not a regular file: \e[38;5;190m%s\e[0m\n' "$file"
    exit 1
  fi
  printf '\e[38;5;190m%s\e[0m\n' "$file"
done

# Ask a y/n question, repeating it until y or n is entered.
ask() {
  while :; do
    read -r -n1 -p "$1" reply
    test -n "$reply" && echo
    case $reply in
    y | Y) return 0 ;;
    n | N) return 1 ;;
    esac
  done
}

# Offer to strip location info from images and to convert HEIC/HEIF
# images to JPEG. The original files are left untouched; modified copies
# are uploaded instead.
tmpdir=$(mktemp -d) || exit 1
trap 'rm -rf "$tmpdir"' EXIT
i=0
for file in "$@"; do
  shift
  i=$((i + 1))
  mime=$(file -b --mime-type "$file")
  case $mime in
  image/*)
    if ! command -v exiftool >/dev/null 2>&1; then
      printf 'exiftool not found; cannot check location info in \e[38;5;190m%s\e[0m\n' "$(basename "$file")" >&2
    elif test -n "$(exiftool -q -q -s3 -a '-gps*' "$file")"; then
      if ask "$(printf 'Remove location info from \e[38;5;190m%s\e[0m [y/n]? ' "$(basename "$file")")"; then
        mkdir -p "$tmpdir/$i/stripped"
        stripped="$tmpdir/$i/stripped/$(basename "$file")"
        # '-gps*=' deletes every GPS* tag in all groups (EXIF, XMP, ...),
        # including bearing/direction/speed which '-geotag=' leaves behind.
        if exiftool -q -q '-gps*=' -o "$stripped" "$file" &&
          test -z "$(exiftool -q -q -s3 -a '-gps*' "$stripped")"; then
          file=$stripped
        else
          echo 'Failed to remove location info' >&2
          exit 1
        fi
      fi
    fi
    ;;
  esac
  case $mime in
  image/heic | image/heif)
    # Offer to upload a JPEG copy instead, since HEIC is less widely
    # supported.
    if ask "$(printf 'Convert \e[38;5;190m%s\e[0m to JPEG [y/n]? ' "$(basename "$file")")"; then
      mkdir -p "$tmpdir/$i"
      name=$(basename "$file")
      jpeg="$tmpdir/$i/${name%.*}.jpg"
      if sips -s format jpeg "$file" --out "$jpeg" >/dev/null 2>&1; then
        file=$jpeg
      else
        echo 'Failed to convert to JPEG' >&2
        exit 1
      fi
    fi
    ;;
  esac
  set -- "$@" "$file"
done

if ask "Share to x0.at [y/n]? "; then
  for file in "$@"; do
    url=$(curl -sF file=@"$file" https://x0.at/)
    printf '\e[38;5;190m%s\e[0m\n' $url >&2
    echo "$url"
  done | paste -s -d ' ' - | tr -d '\n' | pbcopy &&
  printf '%d URL(s) copied to clipboard\n' $#
fi

DROPBOX_PUBLIC=${HOME}/Dropbox/Public

_copyfiletodropbox(){
  mkdir -p "${DROPBOX_PUBLIC}/${1}/"
  cp -R "$2" "${DROPBOX_PUBLIC}/${1}/"
  enc=${2// /%20}
  echo -n "http://dl.dropbox.com/u/3207594/${1}/${enc##*/}" | pbcopy
}

1h() { _copyfiletodropbox "$FUNCNAME" "$1"; }
2h() { _copyfiletodropbox "$FUNCNAME" "$1"; }
24h(){ _copyfiletodropbox "$FUNCNAME" "$1"; }
48h(){ _copyfiletodropbox "$FUNCNAME" "$1"; }
7d() { _copyfiletodropbox "$FUNCNAME" "$1"; }
14d(){ _copyfiletodropbox "$FUNCNAME" "$1"; }
30d(){ _copyfiletodropbox "$FUNCNAME" "$1"; }
90d(){ _copyfiletodropbox "$FUNCNAME" "$1"; }

cdd(){
  if [ ! -z "${1}" ]; then
    APAPAP=`locate -i "${1}" | head -n 1`
    BAPAPAP=`dirname "${APAPAP}"`
    cd "${BAPAPAP}"
  fi
}

vii(){
  if [ ! -z "${1}" ]; then
    APAPAP=`locate -i "${1}" | head -n 1`
    vi "${APAPAP}"
  fi
}

vieww(){
  if [ ! -z "${1}" ]; then
    APAPAP=`locate -i "${1}" | head -n 1`
    view "${APAPAP}"
  fi
}

catt(){
  if [ ! -z "${1}" ]; then
    APAPAP=`locate -i "${1}" | head -n 1`
    cat "${APAPAP}"
  fi
}

openn(){
  if [ ! -z "${1}" ]; then
    APAPAP=`locate -i "${1}" | head -n 1`
    open "${APAPAP}"
  fi
}

alias loc=locc
locc(){
  if [ ! -z "${1}" ]; then
    APAPAP=`locate -i "${1}" | head -n 1`
    echo "${APAPAP}"
  fi
}

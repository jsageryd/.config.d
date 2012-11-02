# Generate sha1 for all files in the specified directory,
# or current directory if none is specified.
ms(){
  directory=.
  [ ! -z "${1}" ] && directory="${1}"
  rm sha1 > /dev/null 2>&1
  find "${directory}" -type f ! -name 'sha1' ! -name '.DS_Store' -exec \
  bash -c 'echo -en "\033[32mCalculating SHA1...\033[0m                      ${1}" ; sha=$(openssl sha1 "${1}") ; echo "${sha}" >> sha1 ; echo -e "\r\033[34m${sha#*= }\033[0m ${1}"' {} {} \;
}

# Uses output from 'openssl sha1' to verify files.
vs(){
  sha1file=sha1
  [ ! -z "${1}" ] && sha1file="${1}"
  BADFILES=0
  DIFFERINGFILES=0
  MISSINGFILES=0
  INTERRUPTED=1
  if [ -f "${sha1file}" ]; then
    while read line; do
      INTERRUPTED=0
      key=${line%=*}
      key=${key#*\(}

      # File name
      file=${key%\)*}

      # Corresponding sha1
      sha=${line#*= }

      echo -en "\033[32mChecking...\033[0m   ${file}"

      opensslsha1=$(openssl sha1 "${file}" 2>/dev/null)

      # Checked sha1
      check=${opensslsha1#*= }

      if [ "${sha}" = "${check}" ]; then
        echo -e "\r\033[34mOK\033[0m            ${file}"
      else
        BADFILES=1
        if [ -e "${file}" ]; then
          let DIFFERINGFILES+=1
          echo -e "\r\033[33mBAD (differs)\033[0m ${file}"
        else
          let MISSINGFILES+=1
          echo -e "\r\033[31mBAD (missing)\033[0m ${file}"
        fi
      fi
    done < "${sha1file}"
    echo
    if [ ${MISSINGFILES} -gt 0 ]; then
      if [ ${MISSINGFILES} -eq 1 ]; then
        echo -e "\033[34mThere was \033[0m${MISSINGFILES}\033[34m missing file.\033[0m"
      else
        echo -e "\033[34mThere were \033[0m${MISSINGFILES}\033[34m missing files.\033[0m"
      fi
    fi
    if [ ${DIFFERINGFILES} -gt 0 ]; then
      if [ ${DIFFERINGFILES} -eq 1 ]; then
        echo -e "\033[34mThere was \033[0m${DIFFERINGFILES}\033[34m differing file.\033[0m"
      else
        echo -e "\033[34mThere were \033[0m${DIFFERINGFILES}\033[34m differing files.\033[0m"
      fi
    fi
    if [ ${BADFILES} -eq 0 ] && [ ${INTERRUPTED} -eq 0 ]; then
      echo -e "\033[34mAll files OK!\033[0m"
    fi
  else
    echo "File not found: ${sha1file}"
    echo "";
    echo "Uses output from 'openssl sha1' to verify files.";
    echo "Run with no argument to read from file 'sha1'.";
    echo "";
    echo "vs <input>";
    echo "";
    echo -e "\033[34m <input>\033[0m\t List of files and checksums to verify (output from 'openssl sha1')";
    echo "";
    echo -en "\033[34m Ex.:\t\033[0m";
    echo "vs";
    echo -e " Verifies files and checksums listed in 'sha1'.";
    echo "";
    echo -en "\033[34m Ex.:\t\033[0m";
    echo "vs checksums";
    echo -e " Verifies files and checksums listed in 'checksums'.";
    echo "";
  fi
}

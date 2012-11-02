# Encrypts files
alias enc=encrypt
encrypt(){
  if [ ! -z "$1" ]; then
    #f=${1%.*}
    #e=${1##*.}
    #openssl des3 -salt -in $1 -out ${f}_enc.${e}
    if [ ! -z "$2" ]; then
      if [ ! -e "$2" ]; then
        openssl des3 -salt -in "$1" -out "$2"
      else
        echo "Output file already exists."
      fi
    else
      openssl des3 -salt -in "$1"
    fi
  else
  # openssl des3 -salt
    echo "";
    echo "Output argument is optional. If no argument is specified, output will be sent to STDOUT.";
    echo "";
    echo "encrypt <input> [output]";
    echo "";
    echo -e "\033[1m <input>\033[0m\t File to encrypt";
    echo -e "\033[1m [output]\033[0m\t File to write to (optional)";
    echo "";
    echo -en "\033[1m Ex.:\t\033[0m";
    echo "enc plain.txt encrypted.txt";
    echo -e " Encrypts the content of plain.txt and saves it to encrypted.txt";
    echo "";
  fi
}

# Decrypts files
alias dec=decrypt
decrypt(){
  if [ ! -z "$1" ]; then
    #f=${1%.*}
    #e=${1##*.}
    #openssl des3 -d -salt -in $1 -out ${f}_dec.${e}
    if [ ! -z "$2" ]; then
      if [ ! -e "$2" ]; then
        openssl des3 -d -salt -in "$1" -out "$2"
      else
        echo "Output file already exists."
      fi
    else
      openssl des3 -d -salt -in "$1"
    fi
  else
    #openssl des3 -d -salt
    echo "";
    echo "Output argument is optional. If no argument is specified, output will be sent to STDOUT.";
    echo "";
    echo "decrypt <input> [output]";
    echo "";
    echo -e "\033[1m <input>\033[0m\t File to decrypt";
    echo -e "\033[1m [output]\033[0m\t File to write to (optional)";
    echo "";
    echo -en "\033[1m Ex.:\t\033[0m";
    echo "dec encrypted.txt dectypted.txt";
    echo -e " Decrypts the content of encrypted.txt and saves it to decrypted.txt";
    echo "";
  fi
}

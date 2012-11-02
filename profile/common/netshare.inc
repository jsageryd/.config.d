# Uses netcat to share a file
alias ns=netshare
netshare(){
  wlanip=$(ifconfig en1 | grep 'inet ' | cut -f 2 -d ' ')
  location="http://${wlanip}:8080"
  if [ ! -z "$1" ]; then
    echo "Sharing at ${location}"
    echo ${location} | pbcopy
    nc -l 8080 < "$1"
  else
    echo ""
    echo "Shares the specified file once at: ${location}"
    echo ""
    echo "netshare <file>"
    echo ""
    echo -e "\033[1m <file>\033[0m\t File to share"
    echo ""
    echo -en "\033[1m Ex.:\t\033[0m"
    echo "netshare myfile.txt"
    echo -e " Serves myfile.txt."
    echo ""
  fi
}

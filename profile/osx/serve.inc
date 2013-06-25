# Serves the current directory
#
# Example:
#   serve # serves current directory at port 8080
#   serve 1234 # serves current directory at port 1234
function serve() {
  [ ! -z $1 ] && port=$1 || port=8080
  myip=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]+\.){3}[0-9]+' | sed 's/inet *//' | grep -v '127.0.0.1')
  open http://$myip:$port
  python -m SimpleHTTPServer $port
}

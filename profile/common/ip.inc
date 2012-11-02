# Get external IP address
alias extip="curl -s dns.loopia.se/checkip/checkip.php | sed 's/^.*: \([^<]*\).*$/\1/'"

# Get IP in DNS record for $1
ip(){
  host -t A "$1" | rev | cut -f 1 -d ' ' | rev
}

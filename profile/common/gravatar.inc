# Opens the gravatar image URL for the specified e-mail address

function gravatar() {
  if [ ! -z $1 ]; then
    md5=$(md5 -qs $(echo $1 | tr -s '[:upper:]' '[:lower:]'))
    url="http://www.gravatar.com/avatar/${md5}?d=404&s=512"
    curl -f ${url} > /dev/null 2>&1 && open ${url} || echo "No such gravatar."
  else
    echo "";
    echo "Opens the gravatar image URL for the specified e-mail address.";
    echo "";
    echo "gravatar <e-mail>";
    echo "";
    echo -e "\033[1m <e-mail>\033[0m\t E-mail in lowercase with no spaces";
    echo "";
    echo -en "\033[1m Ex.:\t\033[0m";
    echo "gravatar user@domain.tld";
    echo -e " Shows the gravatar for user@domain.tld";
    echo "";
  fi
}

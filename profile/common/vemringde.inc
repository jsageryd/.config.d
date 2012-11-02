alias vr=vemringde
vemringde(){
  if [ ! -z "$1" ]; then
    name=`curl -s -f -G -d e=1 -d q="$1" -d n="1" -d stats=1 -d apikey="mWp0CufIOYs2zkRKtrBh7ZQFGHdDySi3JLV5xM4n" http://api.vemringde.se`
    if [ "$name" != "0" ]; then
      echo ${name}
    else
      echo 'Not known.'
    fi
  else
    echo "";
    echo "Looks up the specified phone number at vemringde.se.";
    echo "";
    echo "vemringde <number>";
    echo "";
    echo -e "\033[1m <number>\033[0m\t Number to look up";
    echo "";
    echo -en "\033[1m Ex.:\t\033[0m";
    echo "vemringde 0455619992";
    echo -e " Looks up the phone number 0455619992.";
    echo "";
  fi
}

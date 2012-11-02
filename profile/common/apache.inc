# Creates .htaccess and .htpasswd in the current directory to password protect it.
# If .htaccess already exists it will be ignored.
# If .htpasswd already exists it will be appended to.
apache_lock(){
  if [ ! -z "$1" ]; then
    if [ ! -e .htaccess ]; then
      echo "AuthType  basic" > .htaccess
      echo "AuthName  Authenticate" >> .htaccess
      echo "AuthUserFile  `pwd`/.htpasswd" >> .htaccess
      echo "Require valid-user" >> .htaccess
    else
      echo ".htaccess already exists, ignoring."
    fi
    if [ ! -e .htpasswd ]; then
      htpasswd -c .htpasswd "$1"
    else
      htpasswd .htpasswd "$1"
    fi
  else
    echo "";
    echo "apache_lock creates .htaccess and .htpasswd.";
    echo "If .htaccess already exists it will not be touched.";
    echo "If .htpasswd exists it will be appended to.";
    echo "";
    echo "apache_lock <username>";
    echo "";
    echo -e "\033[1m <username>\033[0m\t The username to set";
    echo "";
    echo -en "\033[1m Ex.:\t\033[0m";
    echo "apache_lock apa";
    echo -e " Creates or adds the user apa.";
    echo "";
  fi
}

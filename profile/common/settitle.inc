# Sets terminal title
alias t=settitle
settitle(){
  echo -n -e "\033]0;$1\007"
}

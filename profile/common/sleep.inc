# Sleeps for $1 minutes
# Example: min 3 && echo Three minutes passed
min() {
  seconds=$(($1 * 60))
  sleep $seconds
}

# Sleep for $1 seconds, for convenient use with above
# Example: min 2 && sec 30 && echo Two and a half minute
alias sec=sleep

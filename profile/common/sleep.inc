# Sleeps for $1 minutes
# Example: min 3 && echo Three minutes passed
min() {
  seconds=$(($1 * 60))
  sleep $seconds
}

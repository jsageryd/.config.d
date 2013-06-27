# Terminal notifier path
PATH=$PATH:/Applications/terminal-notifier.app/Contents/MacOS

# Shorthand for terminal-notifier
# Usage example:
#   notify Notification message
function notify() {
  terminal-notifier -message "$*" > /dev/null 2>&1
}

# Recursive removal of .DS_Store
alias rm_ds_store="find . -name *.DS_Store -type f -delete"
alias find_ds_store="find . -name *.DS_Store -type f"

# Misc, getters
alias netspeed="netstat -w 1 | awk '{ printf(\"In: %.2f KiB/s\tOut: %.2f KiB/s\", \$3/1024, \$6/1024); print \"\"}'"

# Misc, setters
alias chmod_files="find . -type f -exec chmod 644 {} \;"
alias chmod_dirs="find . -type d -exec chmod 755 {} \;"
alias chmod_all="chmod_dirs ; chmod_files"
alias sudo_chmod_all="sudo find . -type d -exec chmod 755 {} \; ; sudo find . -type f -exec chmod 644 {} \;"

# Web downloads
alias dl="cd ~/Downloads/web"

# Book keeping
alias b="cd ~/Documents/iroiro/bokföring/iOrdning"

# Start book keeping application if time zone is CES?T (silly application does not work well in the wrong time zone)
alias bf="date | grep -E CES?T >/dev/null && (cd ~/Documents/iroiro/bokföring/iOrdning && open iroiro.bok) || (echo 'Wrong time zone.')"

# Heroku
alias hce="heroku config:edit"

# Reset audio balance
alias rab="reset-audio-balance"

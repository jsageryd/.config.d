# Stuff related to resource forks

# List forks in current directory
alias list_forks="xattr -l *"

# Recursively remove resource forks. Use with caution.
kill_forks(){
  # Define temp directories to use.
  tmpdir="apa_tmp"
  tmpdir2="bepa_tmp"

  # Die if temp directories already exist.
  [ -d "${tmpdir}" ] || [ -d "${tmpdir2}" ] && echo "Fail: apa_tmp or bepa_tmp exists." && return 1

  # Rsync recursively without keeping resource forks, then move back.
  mkdir apa_tmp
  mv * apa_tmp/
  mkdir bepa_tmp
  rsync -xavWHl apa_tmp bepa_tmp/
  mv bepa_tmp/apa_tmp/* . && rm -rf apa_tmp && rm -rf bepa_tmp
}

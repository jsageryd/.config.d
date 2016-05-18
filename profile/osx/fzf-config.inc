# Extra config for fzf

# Use ag for searching instead of the slow default
if which -s ag; then
  export FZF_DEFAULT_COMMAND='ag -g ""'
fi

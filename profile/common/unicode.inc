# Copies the character corresponding to specified Unicode codepoint to clipboard
# Ex.: unicode 202E
# Copies the Unicode Character 'RIGHT-TO-LEFT OVERRIDE' (U+202E) to clipboard
alias uc=unicode
unicode(){
  if [ ! -z "$1" ]; then
    zsh -c "echo -en '\u$1' | pbcopy"
  else
    echo "No codepoint specified."
  fi
}

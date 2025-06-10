# Dark/light mode
if [ "$ITERM_PROFILE" = "_ $" ]; then
  export COLOUR_SCHEME="light"
else
  export COLOUR_SCHEME="dark"
fi

if [ "$COLOUR_SCHEME" = "light" ]; then
  export TIGRC_USER="${CONFIG_ROOT}/tig/.tigrc_light"
  export GIT_CONFIG_GLOBAL="${CONFIG_ROOT}/git/.gitconfig_light"
fi

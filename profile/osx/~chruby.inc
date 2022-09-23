if [ -e /opt/homebrew/opt/chruby/share/chruby/chruby.sh ]; then
  source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
  chruby ruby-2.4
  source /opt/homebrew/opt/chruby/share/chruby/auto.sh
fi

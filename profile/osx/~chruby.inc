if [ -e /usr/local/opt/chruby/share/chruby/chruby.sh ]; then
  source /usr/local/opt/chruby/share/chruby/chruby.sh
  chruby ruby-2.4
  source /usr/local/opt/chruby/share/chruby/auto.sh
fi

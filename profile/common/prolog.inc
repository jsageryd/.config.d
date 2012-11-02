# This allows using Prolog graphics if you use Terminal.app
if [ -z "$DISPLAY" ]; then export DISPLAY=:0; fi

# Path for swipl
PATH=$PATH:/opt/local/bin

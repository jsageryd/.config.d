if [ "$COLOUR_SCHEME" = "light" ]; then
  alias ag="ag --color-line-number='38;5;244' --color-match='38;5;58;48;5;228' --color-path='48;5;220' --ignore vendor"
else
  alias ag="ag --color-line-number='38;5;244' --color-match='38;5;228;48;5;58' --color-path='38;5;220' --ignore vendor"
fi

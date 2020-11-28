# Usage

This is a collection of status indicators for use in an `awesome` WM `wibox`.

`command-poll-widget.lua` defines a generic widget for running a shell command
and displaying the output.

The various `poll-*` scripts define specific commands for instances of that
widget to display: battery, screen brightness, & volume. They can also be
run standalone.

It is likely that the scripts will need customization for use on other systems.

Running `make` will copy the scripts to `/usr/local/bin` & the widget to the
`awesome` local config dir, `~/.config/awesome`.

# Development

The `python` scripts in this project use `pipenv` for their development environment,
and use `isort` & `black` for their formatting.

# Origin

`command-poll-widget.lua` is derived from the `brightness.lua` widget in
[Pavel Makhov's `awesome-wm-widgets`](https://github.com/streetturtle/awesome-wm-widgets).

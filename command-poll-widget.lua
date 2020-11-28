-------------------------------------------------------------------------------
-- The command poll widget is a simple `wibox` display widget which periodically
-- runs a command & displays its value.
--
-- It is intended to be used as follows:
--
--     local command_poll_widget = require("command-poll-widget")
--
--     ...
--
--
--     command_poll_widget(
--         {
--             get_value_cmd = "<shell command>",
--             value_symbol = "<value symbol>",
--             font = "<font>",
--             poll_interval = "<poll_interval>"
--         }
--     )
--
-- Where:
--     * <shell command> is the command to periodically run
--     * <value symbol> is a symbol to prepend to the displayed command output,
--       to distinguish it visually; the symbol is optional, and if not provided,
--       the widget will not display a symbol
--     * <font> is the font to use; the font is optional & will default to 'Play 9'
--       if not provided
--     * <poll_interval> is the number of seconds to wait between running the
--       command & updating the widget display; the interval is optional & will
--       default to 1 second if not provided
-------------------------------------------------------------------------------
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local spawn = require("awful.spawn")

local VALUE_SYMBOL = ""
local FONT = "Play 9"
local POLL_INTERVAL = 1

local widget = {}

local function worker(args)

    local args = args or {}

    -- A command is always required
    local get_value_cmd = args.get_value_cmd
    -- The symbol is optional and defaults to empty
    local value_symbol = args.value_symbol or VALUE_SYMBOL

    local font = args.font or FONT
    local poll_interval = args.poll_interval or POLL_INTERVAL

    -- The actual text containing the value
    local value_text = wibox.widget.textbox()
    value_text:set_font(font)

    -- The symbol for the value
    local value_icon = wibox.widget.textbox(value_symbol)
    value_icon:set_font(font)

    widget = wibox.widget {
        value_icon,
        value_text,
        layout = wibox.layout.fixed.horizontal,
    }

    local update_widget = function(widget, stdout, _, _, _)
        widget:set_text(stdout)
    end,

    watch(get_value_cmd, poll_interval, update_widget, value_text)

    return widget
end

return setmetatable(widget, { __call = function(_, ...)
    return worker(...)
end })

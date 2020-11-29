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
--             poll_interval = "<poll interval>",
--             bad_exit_color = "<bad exit color>",
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
--     * <poll interval> is the number of seconds to wait between running the
--       command & updating the widget display; the interval is optional & will
--       default to 1 second if not provided
--     * <bad exit color> is the color to set the text to if the exit code of the
--       run command is nonzero; the color is optional, and the widget will default
--       to not setting a different color for nonzero exit codes if not provided
-------------------------------------------------------------------------------
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local spawn = require("awful.spawn")

local VALUE_SYMBOL = ""
local FONT = "Play 9"
local POLL_INTERVAL = 1
local BAD_EXIT_COLOR = ""

local widget = {}

local function worker(args)

    local args = args or {}

    -- A command is always required
    local get_value_cmd = args.get_value_cmd

    -- The symbol is optional and defaults to empty
    local value_symbol = args.value_symbol or VALUE_SYMBOL
    -- The exit color is optional - if it's not provided, we won't change the
    -- color on bad exit codees
    local bad_exit_color = args.bad_exit_color or BAD_EXIT_COLOR

    -- This will fornmat some string `text` with the bad exit text color
    local format_bad_color = function(text)
        return "<span foreground='" .. bad_exit_color .. "'>" .. text .. "</span>"
    end

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

    local update_widget = function(_, stdout, _, _, exitcode)
        -- Since `stdout` is the result of calling a shell command, the last
        -- character is a newline; the textbox widget will refuse to display
        -- anything after a newline, so we have to strip it out
        command_output = stdout:sub(1, -2)

        -- If the exit code is nonzero & a bad exit color has been set, then
        -- color the output &
        if (exitcode ~= 0 and bad_exit_color) then
            value_text:set_markup(format_bad_color(command_output))
            value_icon:set_markup(format_bad_color(value_symbol))
        -- Otherwise, it will be formatted normally, which will overwrite a
        -- previous set color, if the command is "leaving" a bad state
        else
            value_text:set_text(command_output)
            value_icon:set_text(value_symbol)
        end
    end

    watch(get_value_cmd, poll_interval, update_widget, value_text)

    return widget
end

return setmetatable(widget, { __call = function(_, ...)
    return worker(...)
end })

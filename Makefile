# The location where custom user scripts are stored; shpould be in $PATH
SCRIPTS_DIR = /usr/local/bin
# The location of the `awesome` user config
AWESOME_CONFIG = ~/.config/awesome

MOVE = cp $? $@

.PHONY: install
install: \
    $(SCRIPTS_DIR)/poll-* \
    $(AWESOME_CONFIG)/command-poll-widget.lua

$(SCRIPTS_DIR)/poll-% : poll-%
	$(MOVE)

$(AWESOME_CONFIG)/command-poll-widget.lua: command-poll-widget.lua
	$(MOVE)

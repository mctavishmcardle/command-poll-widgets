# The location where custom user scripts are stored; shpould be in $PATH
SCRIPTS_DIR=/usr/local/bin
# The location of the `awesome` user config
AWESOME_CONFIG=~/.config/awesome

.PHONY: install
install: \
		$(SCRIPTS_DIR)/poll-battery \
		$(SCRIPTS_DIR)/poll-brightness \
		$(SCRIPTS_DIR)/poll-volume \
		$(AWESOME_CONFIG)/command-poll-widget.lua
	@echo $@

$(SCRIPTS_DIR)/poll-battery: poll-battery
	cp $? $@

$(SCRIPTS_DIR)/poll-brightness: poll-brightness
	cp $? $@

$(SCRIPTS_DIR)/poll-volume: poll-volume
	cp $? $@

$(AWESOME_CONFIG)/command-poll-widget.lua: command-poll-widget.lua
	cp $? $@

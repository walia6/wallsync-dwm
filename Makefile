# Define a list of targets
TARGETS := apply_Xresources_to_dwm crop_top gen_Xresources_from_wallpaper prepare_random_wallpaper set_random_wallpaper_and_theme wallpaper_theme_loop  # Add the names of your actual targets here

# Use the original user's XDG_CONFIG_HOME or HOME, not root's
USER_HOME := $(shell eval echo ~$(SUDO_USER))
USER_XDG_CONFIG_HOME := $(if $(XDG_CONFIG_HOME),$(XDG_CONFIG_HOME),$(USER_HOME)/.config)
CONFIG_DIR := $(USER_XDG_CONFIG_HOME)/wallsync-dwm

# Install rule to copy all targets, create config directory, set up config.conf with defaults, and adjust ownership
install:
	@# Copy targets to /usr/local/bin
	for target in $(TARGETS); do \
		cp "$$target" /usr/local/bin/; \
	done
	@# Create config directory with mode 700 in the user's config directory
	mkdir -p -m 700 $(CONFIG_DIR)
	@# Change ownership of the config directory to the original user
	chown $(SUDO_USER):$(SUDO_USER) $(CONFIG_DIR)
	@# Append defaults to config.conf only if they are not set
	touch $(CONFIG_DIR)/config.conf
	@grep -q '^wallpaper_dir=' $(CONFIG_DIR)/config.conf || echo "wallpaper_dir=~/Pictures/wallpapers" >> $(CONFIG_DIR)/config.conf
	@grep -q '^xresources_file=' $(CONFIG_DIR)/config.conf || echo "xresources_file=~/.Xresources" >> $(CONFIG_DIR)/config.conf
	@grep -q '^xinterval=' $(CONFIG_DIR)/config.conf || echo "xinterval=30" >> $(CONFIG_DIR)/config.conf
	@# Set permissions for config.conf
	chmod 644 $(CONFIG_DIR)/config.conf
	@# Change ownership of config.conf to the original user
	chown $(SUDO_USER):$(SUDO_USER) $(CONFIG_DIR)/config.conf

# Uninstall rule to remove all targets from /usr/local/bin
uninstall:
	@for target in $(TARGETS); do \
		rm -f /usr/local/bin/$$target; \
	done

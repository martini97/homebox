STAMP_DIR := .stamp

STOW_MARKER := .stow
STOW_TARGETS := $(addprefix stow-,$(patsubst %/,%,$(dir $(wildcard */$(STOW_MARKER)))))
STOW_STAMPS := $(addprefix $(STAMP_DIR)/,$(STOW_TARGETS))

TOOLBOX_DISTRO := fedora
TOOLBOX_RELEASE := 41
TOOLBOX_NAME := homebox

PLAYBOOK := $(CURDIR)/playbook/$(TOOLBOX_NAME).yaml

toolbox-create: $(STAMP_DIR)/toolbox-create

toolbox-cleanup:
	-podman stop --ignore $(TOOLBOX_NAME)
	-toolbox rm --force $(TOOLBOX_NAME)
	-rm $(STAMP_DIR)/toolbox-create

toolbox-setup: toolbox-create
	toolbox run --container $(TOOLBOX_NAME) sudo dnf --assumeyes install ansible
	toolbox run --container $(TOOLBOX_NAME) ansible-playbook $(PLAYBOOK) --ask-become-pass

stow: $(STOW_TARGETS)

$(STAMP_DIR)/toolbox-create:
	toolbox create --distro $(TOOLBOX_DISTRO) --release $(TOOLBOX_RELEASE) $(TOOLBOX_NAME)
	touch $@

$(STOW_TARGETS): %: $(STAMP_DIR)/%

.SECONDEXPANSION:
$(STOW_STAMPS): $(STAMP_DIR)/stow-%: $$(shell find % -type f) | $(STAMP_DIR)
	@stow --ignore=$(STOW_MARKER) --dir=$(CURDIR) --target=$(HOME) --dotfiles $*
	@touch $@

$(STAMP_DIR):
	@mkdir --parents $@

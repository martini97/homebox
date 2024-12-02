STAMP_DIR := .stamp

STOW_MARKER := .stow
STOW_TARGETS := $(addprefix stow-,$(patsubst %/,%,$(dir $(wildcard */$(STOW_MARKER)))))
STOW_STAMPS := $(addprefix $(STAMP_DIR)/,$(STOW_TARGETS))

PLAYBOOK := $(CURDIR)/playbook/main.yaml

.PHONY: playbook
all: pull playbook stow


stow: $(STOW_TARGETS)

.PHONY: playbook
playbook:
	@ansible-playbook playbook/main.yaml --ask-become-pass

.PHONY: pull
pull:
	@git pull --autostash


$(STOW_TARGETS): %: $(STAMP_DIR)/%

.SECONDEXPANSION:
$(STOW_STAMPS): $(STAMP_DIR)/stow-%: $$(shell find % -type f) | $(STAMP_DIR)
	@stow --ignore=$(STOW_MARKER) --dir=$(CURDIR) --target=$(HOME) --dotfiles $*
	@touch $@

$(STAMP_DIR):
	@mkdir --parents $@

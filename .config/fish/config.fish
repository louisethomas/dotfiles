#!/bin/fish

set -U fish_greeting    # remove greeting

zoxide init fish | source

# keybindings 
set -U fish_key_bindings fish_vi_key_bindings
bind \ett peco_todoist_item
bind \etp peco_todoist_project
bind \etl peco_todoist_labels
bind \etc peco_todoist_close
bind \etd peco_todoist_delete

# Interactive shell config
if status is-interactive
    abbr -a -U -- compile 'arduino-cli compile -b arduino:avr:nano:cpu=atmega328old'
    abbr -a -U -- upload 'arduino-cli upload -p /dev/ttyUSB0 -b arduino:avr:nano:cpu=atmega328old'
    abbr -a -U -- upload1 'arduino-cli upload -p /dev/serial/by-path/pci-0000:00:06.0-usb-0:2:1.0-port0 -b arduino:avr:nano:cpu=atmega328old'
    abbr -a -U -- upload2 'arduino-cli upload -p /dev/serial/by-path/pci-0000:00:06.0-usb-0:3:1.0-port0 -b arduino:avr:nano:cpu=atmega328old'
    abbr -a -U -- cd z
end

#!/bin/bash

mkdir -p $HOME/gdrive/personal
mkdir -p $HOME/gdrive/tensorfield 
mkdir -p $HOME/gdrive/shared_tensorfield/corporation
mkdir -p $HOME/gdrive/shared_tensorfield/customer_development
mkdir -p $HOME/gdrive/shared_tensorfield/finance
mkdir -p $HOME/gdrive/shared_tensorfield/marketing
mkdir -p $HOME/gdrive/shared_tensorfield/ml
mkdir -p $HOME/gdrive/shared_tensorfield/papers
mkdir -p $HOME/gdrive/shared_tensorfield/presentations
mkdir -p $HOME/gdrive/shared_tensorfield/product_design
mkdir -p $HOME/gdrive/shared_tensorfield/team_notes
mkdir -p $HOME/gdrive/shared_tensorfield/visas

systemctl --user enable --now $HOME/.config/systemd/user/rclone-mount-gdrive.service

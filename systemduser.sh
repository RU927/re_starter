#!/bin/bash
ln -sf ~/REPOS/re_run/config/systemd/ ~/.config/

systemctl --user daemon reload
systemctl --user enable yandex-disk.service
systemctl --user enable google-drive.service
systemctl --user start yandex-disk.service
systemctl --user start google-drive.service
systemctl --user status yandex-disk.service
systemctl --user status google-drive.service

# systemctl --user add-wants autostart.target yandex-disk.service
# systemctl --user add-wants autostart.target google-drive.service
# systemctl --user set-default autostart.target

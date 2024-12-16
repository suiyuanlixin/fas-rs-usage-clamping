#!/system/bin/sh
# Copyright 2023-2024, shadow3 (@shadow3aaa)
#
# This file is part of fas-rs.
#
# fas-rs is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option)
# any later version.
#
# fas-rs is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along
# with fas-rs. If not, see <https://www.gnu.org/licenses/>.

mode=/dev/fas_rs/mode

switch_mode() {
	echo "$1" > /data/cur_powermode.txt
	sh /data/powercfg/$1.sh
}

case "$1" in
    "init")
        echo fast >$mode
        /data/powercfg.sh $(cat /data/cur_powermode.txt)
        ;;
    "fast" | "pedestal")
        echo fast >$mode
        switch_mode $1
        ;;
    "powersave" | "standby")
        echo powersave >$mode
        switch_mode $1
        ;;
    "balance")
        echo balance >$mode
        switch_mode $1
        ;;
    "performance")
        echo performance >$mode
        switch_mode $1
        ;;
    *)
        echo "Failed to apply unknown action '$1'."
        ;;
esac

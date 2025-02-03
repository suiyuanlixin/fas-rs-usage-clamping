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

MODDIR=${0%/*}
LOCALE=$(getprop persist.sys.locale)
EXTENSIONS=/dev/fas_rs/extensions
DIR=/sdcard/Android/fas-rs
CONF=$DIR/games.toml
EXTENSION_NAME="fas_rs_extension_usage_clamping.lua"
EXTENSION_NAME2="fas_rs_extension_extra_policy.lua"
enable_value=$(cat "/sys/module/cpufreq_clamping/parameters/enable")
mod_value=$(cat "$MODDIR/tem_mod")

local_print() {
	if [ $LOCALE = zh-CN ]; then
		echo "$1"
	else
		echo "$2"
	fi
}

key_check() {
    while true; do
        key_check=$(/system/bin/getevent -qlc 1)
        key_event=$(echo "$key_check" | awk '{ print $3 }' | grep 'KEY_')
        key_status=$(echo "$key_check" | awk '{ print $4 }')
        if [[ "$key_event" == *"KEY_"* && "$key_status" == "DOWN" ]]; then
            keycheck="$key_event"
            break
        fi
    done
    while true; do
        key_check=$(/system/bin/getevent -qlc 1)
        key_event=$(echo "$key_check" | awk '{ print $3 }' | grep 'KEY_')
        key_status=$(echo "$key_check" | awk '{ print $4 }')
        if [[ "$key_event" == *"KEY_"* && "$key_status" == "UP" ]]; then
            break
        fi
    done
}

if [ "$mod_value" = "modify" ]; then
    sed -i '/\[powersave\]/,/^\[/ s/core_temp_thresh = [^ ]*/core_temp_thresh = 75000/' "$CONF"
    sed -i '/\[balance\]/,/^\[/ s/core_temp_thresh = [^ ]*/core_temp_thresh = 85000/' "$CONF"
    sed -i '/\[performance\]/,/^\[/ s/core_temp_thresh = [^ ]*/core_temp_thresh = 95000/' "$CONF"
    sed -i '/\[fast\]/,/^\[/ s/core_temp_thresh = [^ ]*/core_temp_thresh = "disabled"/' "$CONF"
    local_print "- 已覆盖fas-rs核心温控" "- The core temperature control of fas-rs has been overwritten."
elif [ "$mod_value" = "disable" ]; then
    sed -i 's/core_temp_thresh = [^ ]*/core_temp_thresh = "disabled"/g' "$CONF"
    local_print "- 已覆盖fas-rs核心温控" "- The core temperature control of fas-rs has been overwritten."
fi

local_print "- 请选择在Magisk管理器中需要显示的内容：
- 音量↑：模块内容介绍
- 音量↓：模块生效状态" "- Please select the content to be displayed in the Magisk Manager:
- Volume key↑: Introduction to the module content
- Volume key↓: The activation status of the module"
key_check
case "$keycheck" in
    "KEY_VOLUMEUP")
        sed -i "/^description=/s/=.*$/=/" "$MODDIR/module.prop"
        sed -i "/description=/s/$/Frame aware scheduling for android, work with cpufreq clamping. Requires 5.10 or 5.15 kernel and kernel ebpf support./" "$MODDIR/module.prop"
        ;;
    "KEY_VOLUMEDOWN")
        sed -i "/^description=/s/=.*$/=/" "$MODDIR/module.prop"
        if [ -f "$EXTENSIONS/$EXTENSION_NAME" ] && [ -f "$EXTENSIONS/$EXTENSION_NAME2" ]; then
            sed -i "/description=/s/$/[ Extensions loaded ] /" "$MODDIR/module.prop"
        elif [ -f "$EXTENSIONS/$EXTENSION_NAME" ] || [ -f "$EXTENSIONS/$EXTENSION_NAME2" ]; then
            sed -i "/description=/s/$/[ Extension loaded ] /" "$MODDIR/module.prop"
        else
            sed -i "/description=/s/$/[ Extension unloaded ] /" "$MODDIR/module.prop"
        fi
        if lsmod | grep -q "cpufreq_clamping"; then
            sed -i "/description=/s/$/[ Cpufreq_clamping loaded ] /" "$MODDIR/module.prop"
        else
            sed -i "/description=/s/$/[ Cpufreq_clamping unloaded ] /" "$MODDIR/module.prop"
        fi
        if [ "$enable_value" = "1" ]; then
            sed -i "/description=/s/$/[ Cpufreq_clamping enabled ] /" "$MODDIR/module.prop"
        else
            sed -i "/description=/s/$/[ Cpufreq_clamping disabled ] /" "$MODDIR/module.prop"
        fi
        if [ "$mod_value" = "modify" ]; then
            sed -i "/description=/s/$/[ Temperature control modified ] /" "$MODDIR/module.prop"
        elif [ "$mod_value" = "disable" ]; then
            sed -i "/description=/s/$/[ Temperature control disabled ] /" "$MODDIR/module.prop"
        fi
        ;;
esac

echo "- Done"

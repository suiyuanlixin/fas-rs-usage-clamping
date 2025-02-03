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
DIR=/sdcard/Android/fas-rs
CONF=$DIR/games.toml
MERGE_FLAG=$DIR/.need_merge
LOG=$DIR/fas_log.txt
EXTENSIONS=/dev/fas_rs/extensions
soc_model=$(getprop ro.soc.model)
KERNEL_VERSION=`uname -r| sed -n 's/^\([0-9]*\.[0-9]*\).*/\1/p'`
mod_value=$(cat "$MODDIR/tem_mod")

wait_until_login() {
    while [ "$(getprop sys.boot_completed)" != "1" ]; do
        sleep 1
    done
    until [ -d "/data/data/android" ]; do
        sleep 1
    done
}

wait_until_login

sh $MODDIR/vtools/init_vtools.sh $(realpath $MODDIR/module.prop)

resetprop fas-rs-installed true

until [ -d $DIR ]; do
	sleep 1
done

if [ -f $MERGE_FLAG ]; then
	$MODDIR/fas-rs merge $MODDIR/games.toml >$DIR/.update_games.toml
	rm $MERGE_FLAG
	mv $DIR/.update_games.toml $DIR/games.toml
fi

killall fas-rs
RUST_BACKTRACE=1 nohup $MODDIR/fas-rs run $MODDIR/games.toml >$LOG 2>&1 &

sleep 90

insmod $MODDIR/kernelobject/$KERNEL_VERSION/cpufreq_clamping.ko 2>&1
/data/powercfg.sh $(cat /data/cur_powermode.txt)

sh $MODDIR/apply_config.sh

until [ -d $EXTENSIONS ]; do
	sleep 1
done

id=$(awk -F= '/extension_id/ {print $2}' $MODDIR/module.prop)
cp -f $MODDIR/extension/cpufreq_clamping.lua $EXTENSIONS/${id}.lua

if [ "$soc_model" = "SM7675" -o "$soc_model" = "SM8550" ]; then
    cp -f $MODDIR/extension/kalama_extra.lua $EXTENSIONS/fas_rs_extension_extra_policy.lua
elif [ "$soc_model" = "MT6886"* ]; then
    cp -f $MODDIR/extension/sun_extra.lua $EXTENSIONS/fas_rs_extension_extra_policy.lua
else
    cp -f $MODDIR/extension/taro_extra.lua $EXTENSIONS/fas_rs_extension_extra_policy.lua
fi

if [ "$mod_value" = "modify" ]; then
    sed -i '/\[powersave\]/,/^\[/ s/core_temp_thresh = [^ ]*/core_temp_thresh = 75000/' "$CONF"
    sed -i '/\[balance\]/,/^\[/ s/core_temp_thresh = [^ ]*/core_temp_thresh = 85000/' "$CONF"
    sed -i '/\[performance\]/,/^\[/ s/core_temp_thresh = [^ ]*/core_temp_thresh = 95000/' "$CONF"
    sed -i '/\[fast\]/,/^\[/ s/core_temp_thresh = [^ ]*/core_temp_thresh = "disabled"/' "$CONF"
elif [ "$mod_value" = "disable" ]; then
    sed -i 's/core_temp_thresh = [^ ]*/core_temp_thresh = "disabled"/g' "$CONF"
fi

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

DIR=/sdcard/Android/fas-rs
CONF=$DIR/games.toml
MERGE_FLAG=$DIR/.need_merge
LOCALE=$(getprop persist.sys.locale)
KERNEL_VERSION=`uname -r| sed -n 's/^\([0-9]*\.[0-9]*\).*/\1/p'`
WEBROOT_PATH="/data/adb/modules/cpufreq_clamping/webroot"
RECREAT_CPUFREQ_CLAMPING_CONF=1
CPUFREQ_CLAMPING_CONF="/data/cpufreq_clamping.conf"
DEFAULT_CPUFREQ_CLAMPING_CONF=$(cat <<EOF
interval_ms=40
boost_app_switch_ms=150
#cluster0
baseline_freq=1700
margin=300
boost_baseline_freq=2000
max_freq=9999
#cluster1
baseline_freq=1600
margin=300
boost_baseline_freq=2000
max_freq=9999
#cluster2
baseline_freq=1600
margin=300
boost_baseline_freq=2500
max_freq=9999
EOF
)

local_print() {
	if [ $LOCALE = zh-CN ]; then
		ui_print "$1"
	else
		ui_print "$2"
	fi
}

local_echo() {
	if [ $LOCALE = zh-CN ]; then
		echo "$1"
	else
		echo "$2"
	fi
}

creat_conf() {
    if [[ ! -f "$CPUFREQ_CLAMPING_CONF" ]]; then
        local_print "- 配置文件夹：/data/cpufreq_clamping.conf" "- Configuration folder: /data/cpufreq_clamping.conf"
        echo "$DEFAULT_CPUFREQ_CLAMPING_CONF" > "$CPUFREQ_CLAMPING_CONF"
    else
        local_print "- 配置文件夹：/data/cpufreq_clamping.conf" "- Configuration folder: /data/cpufreq_clamping.conf"
    fi
}

recreat_conf() {
    rm "$CPUFREQ_CLAMPING_CONF"
    echo "$DEFAULT_CPUFREQ_CLAMPING_CONF" > "$CPUFREQ_CLAMPING_CONF"
    if [[ -f "$CPUFREQ_CLAMPING_CONF" ]]; then
        local_print "- 配置文件夹：/data/cpufreq_clamping.conf" "- Configuration folder: /data/cpufreq_clamping.conf"
    else
        local_print "- 配置文件夹：/data/cpufreq_clamping.conf" "- Configuration folder: /data/cpufreq_clamping.conf"
    fi
}

if [ $ARCH != arm64 ]; then
	local_print "- 设备不支持, 非arm64设备！" "- Only for arm64 device !"
	abort
elif [ $API -le 30 ]; then
	local_print "- 系统版本过低, 需要安卓12及以上的系统版本版本！" "- Required A12+ !"
	abort
elif uname -r | awk -F. '{if ($1!= 5 || ($1 == 5 && ($2!= 10 && $2!= 15))) exit 0; else exit 1}'; then
    local_print "- 内核版本不支持，仅支持5.10或5.15内核！" "- The kernel version doesn't meet the requirement. Only 5.10 or 5.15 kernel is supported!"
    abort
fi

if [ -f $CONF ]; then
	touch $MERGE_FLAG
else
	mkdir -p $DIR
	cp $MODPATH/games.toml $CONF
fi

cp -f $MODPATH/README_CN.md $DIR/doc_cn.md
cp -f $MODPATH/README_EN.md $DIR/doc_en.md

set_perm_recursive $MODPATH 0 0 0755 0644
set_perm $MODPATH/fas-rs 0 0 0755

local_print "- 配置文件夹：/sdcard/Android/fas-rs" "Configuration folder: /sdcard/Android/fas-rs"
local_echo "updateJson=https://raw.githubusercontent.com/suiyuanlixin/fas-rs-usage-clamping/refs/heads/main/Update/update_zh.json" "updateJson=https://raw.githubusercontent.com/suiyuanlixin/fas-rs-usage-clamping/refs/heads/main/Update/update_en.json" >>$MODPATH/module.prop

resetprop fas-rs-installed true

rmmod cpufreq_clamping 2>/dev/null
insmod $MODPATH/kernelobject/$KERNEL_VERSION/cpufreq_clamping.ko 2>&1

if [ $? -ne 0 ]; then
    local_print "- 载入 cpufreq_clamping.ko 失败！" "- Failed to load cpufreq_clamping.ko !"
	dmesg | grep cpufreq_clamping | tail -n 20
	exit 1
fi

[[ $RECREAT_CPUFREQ_CLAMPING_CONF -eq 1 ]] && recreat_conf || creat_conf

if [ -f "$WEBROOT_PATH/index.html" ]; then
    rm -rf $WEBROOT_PATH/*
    cp -r $MODPATH/webroot/* $WEBROOT_PATH/
fi

sh $MODPATH/vtools/init_vtools.sh $(realpath $MODPATH/module.prop)
/data/powercfg.sh $(cat /data/cur_powermode.txt)

if [ -f "$MODPATH/prop_des" ]; then
    > "$MODPATH/prop_des"
fi

echo "description" > "$MODPATH/prop_des"

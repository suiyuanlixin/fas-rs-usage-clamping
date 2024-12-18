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
EXTENSIONS=/dev/fas_rs/extensions
EXTENSION_NAME="fas_rs_extension_usage_clamping.lua"
prop_des="$MODDIR/prop_des"
des_value=$(cat "$prop_des")

if [ "$des_value" = "description" ]; then
    sed -i "/^description=/s/=.*$/=/" "$MODDIR/module.prop"
    if [ -f "$EXTENSIONS/$EXTENSION_NAME" ]; then
        sed -i "/description=/s/$/[ Extension loaded ] /" "$MODDIR/module.prop"
    else
        sed -i "/description=/s/$/[ Extension unloaded ] /" "$MODDIR/module.prop"
    fi
    if lsmod | grep -q "cpufreq_clamping"; then
        sed -i "/description=/s/$/[ Cpufreq_clamping loaded ] /" "$MODDIR/module.prop"
    else
        sed -i "/description=/s/$/[ Cpufreq_clamping unloaded ] /" "$MODDIR/module.prop"
    fi
    > "$prop_des"
    echo "status" > "$prop_des"
elif [ "$des_value" = "status" ]; then
    sed -i "/^description=/s/=.*$/=/" "$MODDIR/module.prop"
    sed -i "/description=/s/$/Frame aware scheduling for android, work with cpufreq clamping. Requires 5.10 or 5.15 kernel and kernel ebpf support./" "$MODDIR/module.prop"
    > "$prop_des"
    echo "description" > "$prop_des"
fi

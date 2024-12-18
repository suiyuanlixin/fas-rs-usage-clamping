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

propPath=$1
version=$(cat $propPath | grep "^version=" | cut -d "=" -f2)
fas_rs_version=$(cat $propPath | grep "fas_rs_version=" | cut -d "=" -f2)
cpufreq_clamping_version=$(cat $propPath | grep "cpufreq_clamping_version=" | cut -d "=" -f2)
author=$(cat $propPath | grep "^author=" | cut -d "=" -f2)
fas_rs_author=$(cat $propPath | grep "fas_rs_author=" | cut -d "=" -f2)
cpufreq_clamping_author=$(cat $propPath | grep "cpufreq_clamping_author=" | cut -d "=" -f2)

json=$(
	cat <<EOF
{
    "name": "fas-rs-usage-clamping",
    "author": "shadow3&ztc1997&Skyi_Lici",
    "version": "\n- (@$author) fas-rs-usage-clamping: $version\n- (@$fas_rs_author) fas-rs: $fas_rs_version\n- (@$cpufreq_clamping_author) cpufreq_clamping:",
    "versionCode": ${cpufreq_clamping_version},
    "features": {
        "strict": true,
        "pedestal": true
    },
    "module": "fas_rs",
    "state": "/dev/fas_rs/mode",
    "entry": "/data/powercfg.sh",
    "projectUrl": "https://github.com/shadow3aaa/fas-rs"
}
EOF
)

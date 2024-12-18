#!/system/bin/sh

echo 100 > /sys/module/cpufreq_clamping/parameters/interval_ms

echo "0 1700000" > /sys/module/cpufreq_clamping/parameters/limit_freq
echo "1 1400000" > /sys/module/cpufreq_clamping/parameters/limit_freq
echo "2 1400000" > /sys/module/cpufreq_clamping/parameters/limit_freq

echo "0 300000" > /sys/module/cpufreq_clamping/parameters/margin
echo "1 300000" > /sys/module/cpufreq_clamping/parameters/margin
echo "2 300000" > /sys/module/cpufreq_clamping/parameters/margin

echo 1 > /sys/module/cpufreq_clamping/parameters/enable
CONFIG_FILE="/data/cpufreq_clamping.conf"
SYSFS_PATH="/sys/module/cpufreq_clamping/parameters"

interval_ms=$(sed -n 's/^interval_ms=//p' "$CONFIG_FILE")
echo "$interval_ms" > "$SYSFS_PATH/interval_ms"

boost_app_switch_ms=$(sed -n 's/^boost_app_switch_ms=//p' "$CONFIG_FILE")
echo "$boost_app_switch_ms" > "$SYSFS_PATH/boost_app_switch_ms"

for cluster in 0 1 2; do
    baseline_freq=$(sed -n "/^#cluster${cluster}$/,/^#cluster/{ 
        /baseline_freq=/ {
            s/baseline_freq=//p
        }
    }" "$CONFIG_FILE" | head -n 1)

    margin=$(sed -n "/^#cluster${cluster}$/,/^#cluster/{ 
        /margin=/ {
            s/margin=//p
        }
    }" "$CONFIG_FILE" | head -n 1)

    boost_baseline_freq=$(sed -n "/^#cluster${cluster}$/,/^#cluster/{ 
        /boost_baseline_freq=/ {
            s/boost_baseline_freq=//p
        }
    }" "$CONFIG_FILE" | head -n 1)

    baseline_freq_khz=$((baseline_freq * 1000))
    margin_khz=$((margin * 1000))
    boost_baseline_freq_khz=$((boost_baseline_freq * 1000))

    echo "$cluster $baseline_freq_khz" > "$SYSFS_PATH/baseline_freq"
    echo "$cluster $margin_khz" > "$SYSFS_PATH/margin"
    echo "$cluster $boost_baseline_freq_khz" > "$SYSFS_PATH/boost_baseline_freq"
done

API_VERSION = 0

function start_fas()
    os.execute("echo 0 > /sys/module/cpufreq_clamping/parameters/enable")
end

function stop_fas()
    os.execute("echo 1 > /sys/module/cpufreq_clamping/parameters/enable")
end

function load_fas()
    log_info("[cpufreq_clamping] fas-rs load_fas, disable cpufreq_clamping")
    os.execute("echo 0 > /sys/module/cpufreq_clamping/parameters/enable")
end

function unload_fas()
    log_info("[cpufreq_clamping] fas-rs unload_fas, enable cpufreq_clamping")
    os.execute("echo 1 > /sys/module/cpufreq_clamping/parameters/enable")
end

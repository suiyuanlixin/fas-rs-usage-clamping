API_VERSION = 0

function start_fas()
    os.execute("echo 0 > /sys/module/cpufreq_clamping/parameters/enable")
end

function stop_fas()
    os.execute("echo 1 > /sys/module/cpufreq_clamping/parameters/enable")
end

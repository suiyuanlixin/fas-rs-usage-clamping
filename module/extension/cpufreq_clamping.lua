API_VERSION = 0

function load_fas()
    os.execute("echo 0 > /sys/module/cpufreq_clamping/parameters/enable")
end

function unload_fas()
    os.execute("echo 1 > /sys/module/cpufreq_clamping/parameters/enable")
end

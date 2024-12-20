<div align="center">

<img src="assets/icon_li.webp" width="160" height="160" style="display: block; margin: 0 auto;" alt="Image">

# **fas-rs-usage-clamping**

### Frame aware scheduling for android, work with cpufreq clamping

[![简体中文][readme-cn-badge]][readme-cn-url]
[![Stars][stars-badge]][stars-url]
[![Release][release-badge]][release-url]
[![Download][download-badge]][download-url]
[![Telegram][telegram-badge]][telegram-url]

</div>

> **⚠ Warning**: This document is gpt-translated and may contain inaccuracies or errors.

[readme-cn-badge]: https://img.shields.io/badge/README-简体中文-blue.svg?style=for-the-badge&logo=readme
[readme-cn-url]: README.md
[stars-badge]: https://img.shields.io/github/stars/suiyuanlixin/fas-rs-usage-clamping?style=for-the-badge&logo=github
[stars-url]: https://github.com/suiyuanlixin/fas-rs-usage-clamping
[release-badge]: https://img.shields.io/github/v/release/suiyuanlixin/fas-rs-usage-clamping?style=for-the-badge&logo=shell
[release-url]: https://github.com/suiyuanlixin/fas-rs-usage-clamping/releases/latest
[download-badge]: https://img.shields.io/github/downloads/suiyuanlixin/fas-rs-usage-clamping/total?style=for-the-badge
[download-url]: https://github.com/suiyuanlixin/fas-rs-usage-clamping/releases/latest
[telegram-badge]: https://img.shields.io/badge/Group-blue?style=for-the-badge&logo=telegram&label=Telegram
[telegram-url]: https://t.me/fas_rs_official

## **Introduction**

> Although `fas-rs` performs extremely well as a game frame aware scheduling, its inability to control daily usage has become a significant drawback. Can it be improved to meet the needs of daily use while ensuring an excellent gaming experience, thus achieving a good balance between the two? `fas-rs-usage-clamping` is based on this scheduling concept. The CPU frequency controller `cpufreq_clamping` is aware of the utilization in daily use, and the game uses the frame aware scheduling `fas-rs` to minimize all kinds of costs while ensuring smoothness.

- ### **[fas-rs](https://github.com/shadow3aaa/fas-rs)**

  - `fas-rs` is a user-space implementation of `FAS (Frame Aware Scheduling)`, which has the advantage of near-universal compatibility and flexibility on any device compared to the kernel-space `MI FEAS`.
  
- ### **cpufreq_clamping**

  - `cpufreq_clamping` is a simple CPU frequency controller. According to the frequency and utilization, it dynamically limits the CPU from using overly high frequencies and reduces the probability of the CPU idling at high frequencies.
  
- ### **fas-rs-usage-clamping**

  - It's a modified version of the frame aware scheduling `fas-rs` by [@shadow3](https://github.com/shadow3aaa)! It is directly compatible with and has the `cpufreq_clamping` scheduling built in by [@ztc1997](https://github.com/ztc1997) & [@hfdem](https://github.com/hfdem).
  - The module now supports updates within the [`Magisk`](https://github.com/topjohnwu/Magisk) manager. The module supports automatically recognizing the current system language (zh-CN / en-US) to display the flashing script and update log.
  - The "Action" button supported by `Magisk` starting from version 27008 has been added to the module: Click to toggle the "Description" to display the module introduction / the effective status of the module.

## **Extension System**

- To maximize user-space flexibility, `fas-rs` has its own extension system. For development instructions, see the [extension template repository](https://github.com/shadow3aaa/fas-rs-extension-module-template).
- As a modified version of `fas-rs`, `fas-rs-usage-clamping` can use the same extension system as it. However, it is still recommended to use the offset extension as follows:

  - [Fas-rsextension-offset](https://github.com/suiyuanlixin/Fas-rs-extension-offset)
  - [7+gen2-offset-fas-rs-extension](https://github.com/Qi-Serein/7PlusGen2-offset-fas-rs-extension)
  - [fas-gt-dlc](https://github.com/yinwanxi/Fas_gt_dlc)

- Extensions that are not recommended to use or may cause conflicts with `fas-rs-usage-clamping`:

  - [Extension for FAS-RS](https://github.com/AestasBritannia/Extension-for-FAS-RS)
  - [Fas-rs-extension-schedhorizon](https://github.com/suiyuanlixin/Fas-rs-extension-offset#fas-rs-extension-schedhorizon)
  - Fas-rs-extension-limiter
  
## **Customization (Configuration)**

- ### **Configuration Path of fas-rs: `/sdcard/Android/fas-rs/games.toml`**
- ### **Configuration Path of cpufreq_clamping: `/data/cpufreq_clamping.conf`**

- ### **Parameter of fas-rs (`config`) Description:**

  - **keep_std**

    - Type: `bool`
    - `true`: Always keep the standard configuration profile when merging configurations, retaining the local configuration's application list, and other aspects are the same as false \*
    - `false`: See [default behavior of configuration merging](#configuration-merging)

  - **scene_game_list**

    - Type: `bool`
    - `true`: Use scene game list \*
    - `false`: Do not use scene game list

  - `*`: Default configuration

- ### **Parameter of cpufreq_clamping (`config`) Description:**
  
  - **interval_ms**
  
    - Type: `integer`
    - Unit: `milliseconds`
    - The interval for calculating CPU utilization and updating CPU frequency. To reduce overhead, low-precision timing is used, so the minimum interval is 16 milliseconds (interval ≥ 16).
  
  - **boost_app_switch_ms**
  
    - Type: `integer`
    - Unit: `milliseconds`
    - The duration that the boost lasts when switching the topmost application. Low-precision timing is used, and it should be a multiple of the kernel tick (usually 4 milliseconds).
    
  - **baseline_freq**
  
    - Type: `integer`
    - Unit: `Mhz`
    - If the frequency of the cluster is lower than this frequency, it will no longer be restricted.
  
  - **margin**
  
    - Type: `integer`
    - Unit: `Mhz`
    - The target frequency of the cluster = load + margin. The larger the margin, the more aggressive the frequency increase. It is recommended that it should not be lower than 300Mhz.
  
  - **boost_baseline_freq**
  
    - Type: `integer`
    - Unit: `Mhz`
    - The baseline frequency in the boost state.

  - **max_freq**

    - Type: `integer`
    - Unit: `Mhz`
    - Maximum frequency of the cluster.

  - **Note**

    - When setting the parameter, it is required to meet the following condition: margin < baseline_freq < boost_baseline_freq ≤ max_freq.
  
- ### **Game List (`game_list`) Description:**

  - **`"package"` = `target_fps`**

    - `package`: String, application package name
    - `target_fps`: An array (e.g., `[30, 60, 120, 144]` ) or a single integer, representing the target frame rate the game will render to, `fas-rs` will dynamically match at runtime.

- ### **Modes (`powersave` / `balance` / `performance` / `fast`) Description:**

  - #### **Mode Switching:**

    - Similar to `fas-rs`, `fas-rs-usage-clamping` does not have an official mode switching manager. Instead, it is connected to the configuration interface of [`scene`](http://vtools.omarea.com). If you don't use `scene`, the `balance` configuration will be used by default. The performance adjustment of `scene` can adjust the performance modes of both `fas-rs` and `cpufreq_clamping` simultaneously.

  - #### **Mode Parameter Description:**

    - **margin**

      - Type: `integer`
      - Unit: `milliseconds`
      - Allowed frame drop margin, the smaller the margin, the higher the frame rate, the larger the margin, the more power-saving (0 ≤ margin < 1000)

    - **core_temp_thresh**

      - Type: `integer` or `"disabled"`
      - `integer`: Core temperature to trigger thermal control by `fas-rs` (Unit 0.001℃)
      - `"disabled"`: Disable `fas-rs` built-in thermal control

### **Standard Example of `games.toml` Configuration:**

```toml
[config]
keep_std = true
scene_game_list = true

[game_list]
"com.hypergryph.arknights" = [30, 60]
"com.miHoYo.Yuanshen" = [30, 60]
"com.miHoYo.enterprise.NGHSoD" = [30, 60, 90]
"com.miHoYo.hkrpg" = [30, 60]
"com.kurogame.mingchao" = [24, 30, 45, 60]
"com.pwrd.hotta.laohu" = [25, 30, 45, 60, 90]
"com.mojang.minecraftpe" = [60, 90, 120]
"com.netease.party" = [30, 60]
"com.shangyoo.neon" = 60
"com.tencent.tmgp.pubgmhd" = [60, 90, 120]
"com.tencent.tmgp.sgame" = [30, 60, 90, 120]

[powersave]
margin = 3
core_temp_thresh = 80000

[balance]
margin = 2
core_temp_thresh = 90000

[performance]
margin = 1
core_temp_thresh = 95000

[fast]
margin = 0
core_temp_thresh = 95000
```

### **Standard Example of `cpufreq_clamping.conf` Configuration:**

```conf
interval_ms=40
boost_app_switch_ms=150
#cluster0
baseline_freq=1700
margin=300
boost_baseline_freq=2000
#cluster1
baseline_freq=1600
margin=300
boost_baseline_freq=2000
#cluster2
baseline_freq=1600
margin=300
boost_baseline_freq=2500
```

## **Configuration Merging**

- ### `fas-rs` has a built-in configuration merging system to address future configuration feature changes. Its behavior is as follows:

  - Delete configurations in the local configuration that do not exist in the standard configuration
  - Insert configurations that are missing in the local configuration but exist in the standard configuration
  - Retain configurations that exist in both the standard and local configurations

- ### Note

  - Implemented using automatic serialization and deserialization, unable to preserve comments and other non-serialization necessary information
  - The automatic merging configuration during installation will not be applied immediately to avoid affecting the current version's operation but will replace the local configuration with the merged new configuration on the next restart.

- ### Manual Merging

  - The module will automatically call once every time it is installed
  - Manual example

    ```bash
    fas-rs merge /path/to/std/profile
    ```

- ### `cpufreq_clamping` does not have a built-in configuration merging system. If a local configuration is detected, the configuration will not be merged. If no local configuration is detected, the standard configuration will be inserted.

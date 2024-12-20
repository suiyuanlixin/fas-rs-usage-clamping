<div align="center">

<img src="assets/icon_li.webp" width="160" height="160" style="display: block; margin: 0 auto;" alt="Image">

# **fas-rs-usage-clamping**

### Frame aware scheduling for android, work with cpufreq clamping

[![English][readme-en-badge]][readme-en-url]
[![Stars][stars-badge]][stars-url]
[![Release][release-badge]][release-url]
[![Download][download-badge]][download-url]
[![Telegram][telegram-badge]][telegram-url]

</div>

[readme-en-badge]: https://img.shields.io/badge/README-English-blue.svg?style=for-the-badge&logo=readme
[readme-en-url]: README_EN.md
[stars-badge]: https://img.shields.io/github/stars/suiyuanlixin/fas-rs-usage-clamping?style=for-the-badge&logo=github
[stars-url]: https://github.com/suiyuanlixin/fas-rs-usage-clamping
[release-badge]: https://img.shields.io/github/v/release/suiyuanlixin/fas-rs-usage-clamping?style=for-the-badge&logo=shell
[release-url]: https://github.com/suiyuanlixin/fas-rs-usage-clamping/releases/latest
[download-badge]: https://img.shields.io/github/downloads/suiyuanlixin/fas-rs-usage-clamping/total?style=for-the-badge
[download-url]: https://github.com/suiyuanlixin/fas-rs-usage-clamping/releases/latest
[telegram-badge]: https://img.shields.io/badge/Group-blue?style=for-the-badge&logo=telegram&label=Telegram
[telegram-url]: https://t.me/fas_rs_official

## **简介**

> 尽管 `fas-rs` 作为游戏帧感知调度表现极为出色，然而其无法控制日常使用也成为了一大显著缺憾。是否可以将其改进，使其在保障出色游戏体验的同时，亦能满足日常使用的需求，从而实现两者间的良好兼顾与平衡。`fas-rs-usage-clamping` 就是这个调度概念，日常使用利用率感知的 CPU 频率控制器 `cpufreq_clamping` ，游戏使用帧感知调度 `fas-rs` ，在保证流畅度的情况下将各类开销压缩至最低限度。

- ### **[fas-rs](https://github.com/shadow3aaa/fas-rs)**

  - `fas-rs` 是运行在用户态的 `FAS(Frame Aware Scheduling)` 实现，对比核心思路一致但是在内核态的 `MI FEAS` 有着近乎在任何设备通用的兼容性和灵活性方面的优势。
  
- ### **cpufreq_clamping**

  - `cpufreq_clamping` 是一个简易的 CPU 频率控制器，根据频率和利用率，动态限制 CPU 使用过高频率，减少 CPU 在高频空转的概率。
  
- ### **fas-rs-usage-clamping**

  - [@shadow3](https://github.com/shadow3aaa) 帧感知调度 `fas-rs` 的修改版！直接兼容且内置 [@ztc1997](https://github.com/ztc1997) & [@hfdem](https://github.com/hfdem) 的 `cpufreq_clamping` 调度。
  - 模块现已支持 [`Magisk`](https://github.com/topjohnwu/Magisk) 管理器内更新，模块支持自动识别当前系统语言 ( zh-CN / en-US ) 显示刷入脚本及更新日志。
  - 模块现已加入 `Magisk` 27008+ 支持的“操作”按钮：点击切换 Description 显示模块简介 / 模块生效状态。

## **插件系统**

- 为了最大化用户态的灵活性，`fas-rs` 有自己的一套插件系统，开发说明详见[插件的模板仓库](https://github.com/shadow3aaa/fas-rs-extension-module-template)。
- 作为 `fas-rs` 的修改版， `fas-rs-usage-clamping` 可使用与其相同的插件系统，但仍建议使用 offset 插件，如下：

  - [Fas-rsextension-offset](https://github.com/suiyuanlixin/Fas-rs-extension-offset)
  - [7+gen2-offset-fas-rs-extension](https://github.com/Qi-Serein/7PlusGen2-offset-fas-rs-extension)
  - [fas-gt-dlc](https://github.com/yinwanxi/Fas_gt_dlc)

- 不建议使用或可能与 `fas-rs-usage-clamping` 导致冲突的插件：

  - [Extension for FAS-RS](https://github.com/AestasBritannia/Extension-for-FAS-RS)
  - [Fas-rs-extension-schedhorizon](https://github.com/suiyuanlixin/Fas-rs-extension-offset#fas-rs-extension-schedhorizon)
  - Fas-rs-extension-limiter
  
## **自定义(配置)**

- ### **fas-rs 配置路径：`/sdcard/Android/fas-rs/games.toml`**
- ### **cpufreq_clamping 配置路径：`/data/cpufreq_clamping.conf`**

- ### **fas-rs 参数(`config`)说明：**

  - **keep_std**

    - 类型：`bool`
    - `true`：永远在配置合并时保持标准配置的 profile，保留本地配置的应用列表，其它地方和 false 相同 \*
    - `false`：见[配置合并的默认行为](#配置合并)

  - **scene_game_list**

    - 类型：`bool`
    - `true`：使用 scene 游戏列表 \*
    - `false`：不使用 scene 游戏列表

  - `*`：默认配置

- ### **cpufreq_clamping 参数(`config`)说明：**
  
  - **interval_ms**
  
    - 类型：`整数`
    - 单位：`milliseconds`
    - 计算 CPU 利用率并更新 CPU 频率的间隔，为减少开销使用低精度计时，因此最少间隔16毫秒(interval ≥ 16)
  
  - **boost_app_switch_ms**
  
    - 类型：`整数`
    - 单位：`milliseconds`
    - 切换最上层应用时 boost 持续的时间，低精度计时，为内核嘀嗒（通常为4毫秒）的倍数
    
  - **baseline_freq**
  
    - 类型：`整数`
    - 单位：`Mhz`
    - 如果该集群的频率低于此频率，将不再限制
  
  - **margin**
  
    - 类型：`整数`
    - 单位：`Mhz`
    - 该集群的目标频率=负载+余量，余量越大升频越积极，建议不要低于300Mhz
  
  - **boost_baseline_freq**
  
    - 类型：`整数`
    - 单位：`Mhz`
    - boost状态下的基准频率

  - **max_freq**

    - 类型：`整数`
    - 单位：`Mhz`
    - 集群最大频率

  - **注意**

    - 在设置参数是需满足：余量（margin）< 基准频率（baseline_freq）< boost基准频率（boost_baseline_freq）≤ 最大频率（max_freq）
- ### **游戏列表(`game_list`)说明：**

  - **`"package"` = `target_fps`**

    - `package`：字符串，应用包名
    - `target_fps`：一个数组(如 `[30，60，120，144]` )或者单个整数，表示游戏会渲染到的目标帧率，`fas-rs` 会在运行时动态匹配

- ### **模式(`powersave` / `balance` / `performance` / `fast`)说明：**

  - #### **模式切换：**

    - 与 `fas-rs` 相同，`fas-rs-usage-clamping` 没有官方的切换模式的管理器，而是接入了 [`scene`](http://vtools.omarea.com) 的配置接口，如果你不用 `scene` 则默认使用 `balance` 的配置。 `scene` 的性能调节可同时调节 `fas-rs` 和 `cpufreq_clamping` 的性能模式。

  - #### **模式参数说明：**

    - **margin**

      - 类型：`整数`
      - 单位：`milliseconds`
      - 允许的掉帧余量，越小帧率越高，越大越省电(0 ≤ margin < 1000)

    - **core_temp_thresh**

      - 类型：`整数` 或者 `"disabled"`
      - `整数`：让 `fas-rs` 触发温控的核心温度(单位0.001℃)
      - `"disabled"`：关闭 `fas-rs` 内置温控

### **`games.toml` 配置标准例：**

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

### **`cpufreq_clamping.conf` 配置标准例：**

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

## **配置合并**

- ### `fas-rs` 内置配置合并系统，来解决未来的配置功能变动问题。它的行为如下：

  - 删除本地配置中，标准配置不存在的配置
  - 插入本地配置缺少，标准配置存在的配置
  - 保留标准配置和本地配置都存在的配置

- ### 注意

  - 使用自动序列化和反序列化实现，无法保存注释等非序列化必须信息
  - 安装时的自动合并配置不会马上应用，不然可能会影响现版本运行，而是会在下一次重启时用合并后的新配置替换掉本地的

- ### 手动合并

  - 模块每次安装都会自动调用一次
  - 手动例

    ```bash
    fas-rs merge /path/to/std/profile
    ```

- ### `cpufreq_clamping` 未内置配置合并系统。若检测到本地存在配置将不会合并配置，若未检测到本地存在配置将插入标准配置。

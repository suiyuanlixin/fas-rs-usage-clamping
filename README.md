# **fas-rs-usage-clamping**
## **简介**
> 尽管 `fas-rs` 作为游戏帧感知调度表现极为出色，然而其无法控制日常使用也成为了一大显著缺憾。是否可以将其改进，使其在保障出色游戏体验的同时，亦能满足日常使用的需求，从而实现两者间的良好兼顾与平衡。 `fas-rs-usage-clamping` 就是这个调度概念，日常使用利用率感知的 CPU 频率控制器 `cpufreq_clamping` ，游戏使用帧感知调度 `fas-rs` ，在保证流畅度的情况下将各类开销压缩至最低限度。
- ### **[fas-rs](https://github.com/shadow3aaa/fas-rs)**
  - `fas-rs` 是运行在用户态的 `FAS(Frame Aware Scheduling)` 实现，对比核心思路一致但是在内核态的 `MI FEAS` 有着近乎在任何设备通用的兼容性和灵活性方面的优势。
- ### **cpufreq_clamping**
  - `cpufreq_clamping` 是一个简易的 CPU 频率控制器，根据频率和利用率，动态限制 CPU 使用过高频率，减少 CPU 在高频空转的概率。
- ### **fas-rs-usage-clamping**
  - [@shadow3](https://github.com/shadow3aaa) 帧感知调度 `fas-rs` 的修改版！直接兼容且内置 [@ztc1997](https://github.com/ztc1997) & [@hfdem](https://github.com/hfdem) 的 `cpufreq_clamping` 调度。 



与 `fas-rs` 相同，接入了 [`scene`](http://vtools.omarea.com) 的配置接口，如果你不用 `scene` 则默认使用 `balance` 的配置。 `scene` 的性能调节可同时调节 `fas-rs` 和 `cpufreq_clamping` 的性能模式。日常使用会自动切换为 `cpufreq_clamping` 调度，启动游戏时会自动关闭 `cpufreq_clamping` 调度，并由 `fas-rs` 接管调度。模块现已支持 [`Magisk`](https://github.com/topjohnwu/Magisk) 管理器内更新，模块支持自动识别当前系统语言 ( zh-CN / en-US ) 显示刷入脚本及更新日志。

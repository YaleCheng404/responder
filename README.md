# Responder — FPGA-based Buzzer System

## 项目简介

Responder 是一个基于 FPGA 的抢答器系统，采用 Verilog 实现。改进后的版本在代码结构、注释和模块划分上更加清晰，便于阅读、维护和扩展，可用于教学实验或竞赛型抢答器的快速开发。

## 功能模块

- **Sel_module**：负责按键扫描、玩家锁存、答题状态管理，并产生蜂鸣器提示窗口和计时开始信号。
- **Timer_module**：实现基于分频的倒计时逻辑，在时间接近结束时触发超时提示，同时提供时间截止锁存信号。
- **Buzzer_module**：根据不同的事件（抢答、答对、超时）输出对应的蜂鸣音调，并在空闲状态下保持静音。
- **Digitron_NumDisplay_module**：对七段数码管进行多路复用，显示剩余时间和当前抢答的玩家编号。
- **responder.v**：顶层文件，将各个子模块连接成完整的系统。

## 项目结构

```
responder/
├── Buzzer_module.v                 // 蜂鸣器控制逻辑
├── Digitron_NumDisplay_module.v    // 数码管多路复用显示
├── README.md
├── Sel_module.v                    // 玩家选择与状态管理
├── Timer_module.v                  // 倒计时控制与超时提示
├── responder.adc                   // 引脚约束文件
└── responder.v                     // 顶层集成
```

## 构建提示

1. 将 `responder.adc` 中的引脚约束导入目标 FPGA 开发环境。
2. 设定系统时钟为 50 MHz（或根据实际硬件调整 `Timer_module` 中的分频系数）。
3. 编译综合后烧录到开发板即可完成部署。

## 开源许可

本项目采用 [GNU 通用公共许可证 v3.0（GPL-3.0）](https://www.gnu.org/licenses/gpl-3.0.html) 进行授权。您可以自由使用、修改和分发本项目，但需保留原作者信息，并在发布的衍生作品中注明相同的许可协议。

## License

This project is licensed under the GNU General Public License v3.0 (GPL-3.0). You are free to use, modify, and distribute this project, provided that you retain the original author information and include the same license in derivative works.

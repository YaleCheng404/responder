# Responder — FPGA-based Buzzer System

## 项目简介

这是一个基于 FPGA 的抢答器系统，旨在提供高效、稳定的答题响应功能。项目采用 Verilog 编写，结构清晰，适合用于教学和竞赛场景。

## 功能特点

* **模块化设计**：包括计时器、选择器、蜂鸣器控制等模块，便于扩展和维护。
* **高效响应**：优化的硬件逻辑，实现快速的答题响应。
* **易于集成**：可与其他 FPGA 项目或外部设备进行接口对接。

## 项目结构

```
responder/
├── LICENSE
├── README.md
├── Sel_module.v
├── Timer_module.v
├── Buzzer_module.v
├── Digitron_NumDisplay_module.v
└── responder.adc
```

## 开源许可

本项目采用 [GNU 通用公共许可证 v3.0（GPL-3.0）](https://www.gnu.org/licenses/gpl-3.0.html) 进行授权。您可以自由使用、修改和分发本项目，但需保留原作者信息，并在发布的衍生作品中注明相同的许可协议。

## License

This project is licensed under the GNU General Public License v3.0 (GPL-3.0). You are free to use, modify, and distribute this project, provided that you retain the original author information and include the same license in derivative works.

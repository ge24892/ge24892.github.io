+++
title = "LeRobot WAM 世界模型"
description = "在 MuJoCo 中搭建 LeRobot SO-101 抓取环境并训练 WAM 世界模型，仿真抓放成功率达到 95%。"
date = 2026-03-01 # 项目页需要日期（显示在标题下方），这里是简历中项目经历的起始时间

[extra]
lang = "zh"
toc = true
+++

## 项目简介

在 MuJoCo 中搭建 LeRobot SO-101 机械臂的抓取环境，训练并评估 WAM 世界模型：学习如何从视觉观测和机器人本体状态预测未来的动作与状态序列，并把同一套数据流程迁移到真机。

## 主要工作

- 在 MuJoCo 中设置 LeRobot SO-101 机械臂用于采集抓取数据，数据只包含夹爪相机图像与关节角度，并随机化抓取物体的位置
- 深入研究 WAM（LeRobot）架构，理解通过视觉观测和机器人本体状态预测动作与状态序列（state sequence）的原理
- 掌握 Diffusion Transformer（DiT 扩散模型）、VAE（变分自编码器），以及交叉注意力机制与 CNN
- 采集并预处理 SO-101 真机抓取数据，将图像统一为 224×448 以匹配 FastWAM 的输入规格，并完成云端调试

## 结果

- 训练 LeRobot 世界模型，在 MuJoCo 仿真环境中的抓放达到 95% 成功率，说明 WAM 能够从视频数据中学习物理规律

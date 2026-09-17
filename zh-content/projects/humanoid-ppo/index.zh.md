+++
title = "人形机器人强化学习（PPO）"
description = "用 PyTorch 从零实现 PPO，完成连续控制任务，并在 Isaac Lab 中训练人形机器人稳态行走。"
date = 2026-03-01 # 项目页需要日期（显示在标题下方），这里是简历中项目经历的起始时间

[extra]
lang = "zh"
toc = true
+++

## 项目简介

从强化学习基础开始，自己实现 PPO 训练流程，先在简单连续控制任务上验证，再放到 Isaac Lab 里训练人形机器人行走。

## 主要工作

- 系统学习贝尔曼方程、Model Free / Model Based、策略梯度（Policy Gradient）、Q-Learning 等强化学习概念
- 使用 PyTorch 搭建前馈网络（feed forward network）并实现 PPO 训练流程，完成单摆平衡等连续控制任务
- 分析某些任务训练失败的原因，发现奖励信号（reward）稀疏且设计不当会让 PPO 缺乏有效反馈、陷入局部最优
- 实现学习率退火（LR annealing）与 mini-batch 训练机制，在 Isaac Lab 中通过 PPO 算法训练人形机器人稳态行走

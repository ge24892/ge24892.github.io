+++
title = "Humanoid Reinforcement Learning (PPO)"
description = "Implemented PPO from scratch in PyTorch, solved continuous-control tasks, and trained a humanoid to walk in Isaac Lab."
date = 2026-03-01 # project pages need a date (shown under the title); this is the start of the project period on the resume

[extra]
lang = "en"
toc = true
+++

## Overview

Starting from the fundamentals of reinforcement learning, I implemented the PPO
training loop myself, validated it on simple continuous-control tasks, and then
used it to train a humanoid to walk in Isaac Lab.

## What I did

- Worked through the Bellman equation, model-free vs. model-based methods, policy
  gradients, and Q-learning
- Built feed-forward networks in PyTorch and implemented the full PPO training
  loop, solving continuous-control tasks such as pendulum balancing
- Diagnosed failing training runs and found that sparse, badly shaped rewards left
  PPO without useful feedback, trapping it in a local optimum
- Added learning-rate annealing and mini-batch training, then trained a humanoid to
  walk stably with PPO in Isaac Lab

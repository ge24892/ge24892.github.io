+++
title = "VLA Model Training"
description = "Fine-tuned GR00T and π0 vision-language-action policies on self-collected data, using open-loop evaluation and on-robot tuning to reach 90% success."
date = 2026-03-01 # project pages need a date (shown under the title); this is the start of the project period on the resume

[extra]
lang = "en"
toc = true
+++

## Overview

Fine-tuning vision-language-action (VLA) policies on pick-and-place data from my
own six-axis arm — covering the whole loop from data collection and training to
open-loop evaluation, on-robot deployment, and tuning.

## What I did

- Full fine-tuning of NVIDIA's GR00T VLA model on 60 episodes of self-collected
  teleoperated pick-and-place data from a six-axis arm
- Ran open-loop evaluation on the fine-tuned model and used the MSE against the
  ground-truth actions to decide on raising fine-tuning to 20k steps
- Traced repeated wrist-camera disconnects through the Ubuntu kernel log and fixed
  the failing data collection by disabling USB autosuspend with a udev rule
- Turned on-robot failure cases into dataset fixes: collected 100 more
  pick-and-place episodes, improved the scene layout and manipulation style, and
  widened the model's scene generalization
- Noticed that training decoded video with PyAV, diagnosed a TorchCodec
  version-compatibility problem, and cut training time to a quarter of what it was
  by speeding up each step
- Tuned RTC chunked inference to remove on-robot jitter: 15 Hz policy rate with 2×
  action interpolation for ~30 Hz smooth motor commands; ruled out queue and
  camera blocking, verified the fix on the real robot, and built a failure-mode
  framework linking control smoothness to model quality
- LoRA fine-tuning of Physical Intelligence's π0 VLA model, logging learning-rate
  schedules and loss curves in Weights & Biases to tune hyperparameters

## Results

- Full fine-tuning of GR00T reached 70% pick-and-place success; raising
  fine-tuning to 20k steps pushed it to 90%

+++
title = "Sim2Real: Simulation to Real Robot"
description = "Used domain randomization in Isaac Sim and simulation-only fine-tuning to push real-robot pick-and-place success to 80%."
date = 2026-03-01 # project pages need a date (shown under the title); this is the start of the project period on the resume

[extra]
lang = "en"
toc = true
+++

## Overview

Studying where the simulation-to-real (Sim2Real) gap comes from: building a
pick-and-place scene in NVIDIA Isaac Sim that mirrors the real setup as closely as
possible, using domain randomization to make the policy generalize, and gradually
removing its dependence on real-robot data.

## What I did

- Set up the pick-and-place scene in NVIDIA Isaac Sim and tuned the simulated
  camera parameters so that simulation matched the real setup closely, narrowing
  the Sim2Real gap
- Randomized lighting, camera angle, object pose, object count, and object weight
  in simulation, and collected teleoperated datasets to improve generalization
- Fine-tuned the policy on a mix of 20 real and 70 simulated episodes, improving
  real-robot generalization over object pose and weight
- Fine-tuned the GR00T VLA model on simulation-only data and deployed it in both
  simulation and the real robot, comparing success rates to expose the Sim2Real gap
- Compared grasping behavior in simulation and reality to identify the camera as
  the main source of the gap, then doubled the randomization range on the X axis
  and camera angle
- Combined the wider camera randomization with the SAGE framework and fine-tuned
  the GR00T VLA model on 110 simulation-only episodes

## Results

- Training on simulated + real data reached 70% real-robot success with better
  generalization
- Simulation-only fine-tuning reached 70% in simulation but 40% on the real robot,
  quantifying the Sim2Real gap
- With stronger camera randomization and the SAGE framework, simulation-only
  training reached 80% real-robot success

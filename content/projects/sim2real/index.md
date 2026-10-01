+++
title = "Sim2Real: Simulation to Real Robot"
description = "Used domain randomization in Isaac Sim and simulation-only fine-tuning to push real-robot pick-and-place success to 80%."
date = 2026-03-01 # project pages need a date (shown under the title); this is the start of the project period on the resume

[extra]
lang = "en"
toc = true
+++

## Overview

Studying where the simulation-to-real gap comes from: building a
robot task environment that mirrors the sim setup as closely as
possible, using domain randomization to make the policy generalize.

## What I did

- Set up the pick-and-place scene in NVIDIA Isaac Sim and tuned the simulated
  camera parameters so that simulation matched the real setup closely, narrowing
  the Sim2Real gap
- Randomized lighting, camera angle, object pose, object count, and object weight
  in simulation, and collected teleoperated datasets to improve generalization

## Todo
- Train model based on simulation teleoperation datasets
- Train and Evaluate trianed model in Isaac Sim
- Evaluate in real life

+++
title = "LeRobot WAM World Model"
description = "Built a LeRobot SO-101 pick-and-place setup in MuJoCo and trained a WAM world model, reaching 95% success in simulation."
date = 2026-03-01 # project pages need a date (shown under the title); this is the start of the project period on the resume

[extra]
lang = "en"
toc = true
+++

## Overview

A LeRobot SO-101 arm picking and placing objects in MuJoCo, used to train and
evaluate a WAM world model: learning to predict future actions and state
sequences from visual observations and the robot's own state, with the same data
pipeline carried over to the real robot.

## What I did

- Set up a LeRobot SO-101 arm in MuJoCo to collect grasping data containing only
  the gripper camera image and joint angles, with randomized object positions
- Studied the WAM (LeRobot) architecture to understand how it predicts action and
  state sequences from visual observations and the robot's proprioceptive state
- Worked with Diffusion Transformers (DiT), variational autoencoders (VAE),
  cross-attention, and CNNs
- Collected and preprocessed real SO-101 grasping data, standardizing images to
  224×448 to match the FastWAM input format, and debugged the pipeline on a cloud GPU

## Results

- Trained the LeRobot world model to 95% pick-and-place success in the MuJoCo
  simulation, showing that WAM can learn physical dynamics from video data

+++
title = "VLA Model Training"
description = "Fine-tuned GR00T VLA model on teleoperation data."
date = 2026-03-01 # project pages need a date (shown under the title); this is the start of the project period on the resume

[extra]
lang = "en"
toc = true
+++

## Overview

Fine-tuning VLA model on pick-and-place teleoperation data.


<!-- TODO: example caption — rewrite in your own words -->
{{ <figure src="training.png" alt="Weights & Biases dashboard with six charts over 20k training steps" caption="Log for 20k-step GR00T N1.7" width="1644" height="783" page /> }}

<!-- TODO: example caption — rewrite in your own words -->
{{ <figure src="rerun.png" alt="Rerun viewer showing front & wrist camera streams during teleoperation" caption="Rerun viewer showing front & wrist camera streams during teleoperation" width="1000" height="700" page /> }}

<!-- TODO: example caption — rewrite in your own words -->
{{ <figure src="sim_real.png" alt="Isaac Sim on the left, real robot cell on the right" caption="Isaac Sim on the left, real robot cell on the right" width="1781" height="917" page /> }}

- Post-trained GR00T VLA model on 60 episodes of teleoperation data from a SO-101
- Traced repeated wrist-camera disconnects through the Ubuntu kernel log, disabling USB autosuspend seems to solve this
- Collected additional episodes to a total of 100, also improved the scene layout and manipulation style (more conservative action, higher margin of error)
- Noticed that training decoded video with PyAV, diagnosed a TorchCodec
  version-compatibility problem, cut training time 1/4
- Tuned RTC chunked inference for jittery action: 15 Hz policy rate with 2×
  action interpolation
- Use Weights&Biases logs to check on learning-rate and loss curves

# Fail Case (60 Episodes)
Having vial place in positions not shown in demonstration dataset positions cause failure.
<video controls preload="metadata" playsinline poster="fail_case_poster.jpg" src="fail_case.mp4"></video>

# Sucess (100 Episodes)
The additional 40 episodes included the vial in more positions on the grey mat.
<video controls preload="metadata" playsinline poster="thumb.jpg" src="2_vial_sucess.mp4"></video>


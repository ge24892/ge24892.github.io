+++
template = "home.html"
aliases = ["/projects/"] # the projects page was merged into this page

[extra]
lang = "en"

# Show footer in home page
footer = false

# Show a few recent posts in home page
# (set to false if you don't want the post list below)
recent = true
recent_max = 5
recent_more_text = "more »"
+++

I'm a master's student in Robotics and Control at Columbia University, expecting
to graduate in January 2027, after a BS in Computer Engineering at UC Davis.

My work is mostly robot learning: fine-tuning VLA (vision-language-action) models
on real data, world models, and simulation-to-real (Sim2Real) transfer. I've done
pick-and-place, teleoperated data collection and on-robot deployment on six-axis
arms and humanoids, plus some embedded-systems coursework.

{{ <collection path="content/projects/projects.toml" section /> }}

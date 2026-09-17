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

{{ <collection path="content/projects/projects.toml" section /> }}

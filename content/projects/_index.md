+++
title = "Projects"
description = "Things I have built."
template = "prose.html"
page_template = "post.html"
insert_anchor_links = "right"
render = false # the project list lives on the home page now; this section only hosts the project pages

[extra]
lang = "en"

title = "Projects"
subtitle = ""
back_to_top = true # show the back-to-top button on project pages
back_to_home = true # this section has no list page of its own (render = false), so "← Back" goes home
+++

<!-- TODO: write a short intro for this page.

     The list below is rendered from `projects.toml` in this folder.
     Replace the placeholder items there with your own projects.

     Project detail pages live in this folder too, e.g. `blackjack/index.md`
     (a `date` is required, see the note in the README). Add an entry to
     `projects.toml` with `link = "/projects/<folder>/"` to list it. -->

{{ <collection file="projects.toml" section /> }}

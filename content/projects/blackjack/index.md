+++
title = "BlackJack"
description = "TODO: one-line description of this project."
date = 2025-11-18
# updated = 2026-08-18
aliases = ["/posts/blackjack/"] # old URL of this page, kept as a redirect

[taxonomies]
# tags = ["embedded", "c"]
# categories = ["coursework"]

[extra]
lang = "en"
toc = true
# featured = true
# og_image = "IMG_0220.webp"
+++

### Overview
Ziyu He & Erik Soto

Two players play on respective circuit board with CC3200 Launchpad. Players uses poker chips to put in their bet amount with poker chips. Color sensor will pick up bet amount and log the amount of money in the pot. The player will then use an IR TV controller to either continue bet or stand.

A recovery function is also implemented incase an accidental power loss.

Components:
- 2x CC3200 TI Launchpads
- 2x TCS34725 RGB Color Sensor 
- 2x 128x128 RGB OLED Display Module
- 2x IR TV remotes
- 2x IR Receivers

### Card Game Implementation


We began by implementing the card component on our OLED. Using techniques from
our Lab 2 project, we developed a function to draw cards by:

- Drawing a rectangle to represent the card.
- Calculating the text placement based on the rectangle's dimensions and calling
  a text-drawing function (Outstr) to render the card's value and suit.
- Automatically setting the text color according to the suit.

<!-- TODO: continue the writeup here. The media below is gathered in one
     section for now — move each item inline where it belongs and replace the
     placeholder captions. Images are colocated with this page, videos are
     referenced by their relative filename. -->


{{ <figure src="bet.jpg" caption="Betting Page" page /> }}

{{ <figure src="image0.jpg" caption="Board Setup" page /> }}

{{ <figure src="image1.jpg" caption="Welcome Screen" page /> }}

{{ <figure src="image2.jpg" caption="Startup Recovery" page /> }}

{{ <figure src="IMG_0220.webp" caption="Stand/Play UI" page /> }}

### Video Demonstration

<video controls preload="metadata" src="video.mp4"></video>

<video controls preload="metadata" src="IMG_0210.mp4"></video>

<video controls preload="metadata" src="IMG_0219-2.mp4"></video>

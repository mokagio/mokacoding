---
date: 2013-07-26
title: What I did in a week...
tags:
- CoreData
- iOS
- Open Source
- Ruby on Rails
- TDD
slug: what-i-did-in-a-week
description: A recap of what I developed during an unusual week left by myself without neither girlfriend nor friends.
---

As promised one <a href="http://amokafullofstuff.wordpress.com/2013/07/17/a-week-of-time/" target="_blank">week ago</a>, here's a report of what I managed to do in this unusually full of free time week.

I've caught up with Arrow and Game of Thrones. The Red Wedding was better in the book, in my opinion.

Oh! Yes... I did some coding as well :D I've completed the MVP of my iOS app, and I have a working and tweeting setup of the Twitter based Rails App.

###iOS

I've built a simple app using CoreData and <a href="https://github.com/magicalpanda/MagicalRecord" target="_blank">MagicalRecod</a> for the data storage, focusing on a simple gesture based UX, powered by <a href="https://github.com/mystcolor/JTGestureBasedTableViewDemo" target="_blank">JTGestureBasedTableView</a>, with an iOS7ish look. The idea was to roll it out on <a href="https://testflightapp.com/" target="_blank">TestFlight</a> for a week or two and then submit, but the recent cracker attack at Apple have delayed plans. I also used my two WIP pods <a href="https://github.com/mokagio/MGCraftman" target="_blank">MGCraftman</a> and <a href="https://github.com/mokagio/MGObjectiveUtils" target="_blank">MGObjectiveUtils</a>, but the project is simple so I didn't have the occasion to add stuff to them.

###Rails

To implement my Twitter based web app I've relied on the <a href="https://github.com/sferik/twitter" target="_blank">twitter</a> gem, which does all the dirty work for me. I'm using <a href="http://haml.info/" target="_blank">Haml</a> for the templates, I love it, so minimal and clear. I'm also gonna use <a href="http://sass-lang.com/" target="_blank">SASS</a> for the styling. So far I've only been using <a href="http://lesscss.org/" target="_blank">LESS</a>, so I decided to give it a twist.

###Good Practices

Both the projects are obviously being implemented in a as much test driven way as possible! <a href="https://github.com/rspec/rspec" target="_blank">rspec</a> and <a href="https://github.com/bblimke/webmock" target="_blank">webmock</a> on the Ruby side, <a href="https://github.com/allending/Kiwi" target="_blank">Kiwi</a> on the Objective-C one. Neat!

Finally my simple <a href="https://github.com/facebook/xctool/pull/106" target="_blank">PR on xctool</a> has been merged, and I'm proud of it. And surprised no one thought about coloring the result output before...

That's all. I'm overall satisfied of what I managed to build. Although I could have avoided watching half a season of Arrow in two days while coding and focusing more... -.-

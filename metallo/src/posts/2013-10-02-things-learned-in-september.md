---
date: 2013-10-02
title: Some things I learned in September
tags:
- iOS
- Objective-C
- Ruby
- Layout
- CSS
- Open Source
- Node.js
- Data Visualization
- Jenkins
description: A quick summary and memo of interesting things I've learned in September
---

###Javascript and Data Visualization

My company wanted a custom viewer for analytics data, perfect occasion for experiment with data visualization powered by Javascript. I started by taking a look at [D3.js](http://d3js.org/), which is the library used by the GitHub guys to draw their amazing repo graphs. It's incredibly powerful, but requires quite a bit of coding to get stuff done. I then used [Chart.js](https://github.com/nnnick/Chart.js) for a bit. It's smaller, simpler, and faster to learn. This all comes with the downside of being less powerful, and with not enough of the features I needed out of the box. Also the development seems to be going really slow at the moment. So now I'm working with [gRaphaël](http://g.raphaeljs.com/), it's built on top of [Raphaël](http://raphaeljs.com/) and has more of the things I was looking for ready made.

###Node, node, node!

With the project I mentioned above I finally had the occasion to spend company time working on [Node.js](nodejs.org). I like how lighter it is compared to Rails, and I'm definitely gonna keep experimenting with it.

In fact I used [Node + Heroku](https://devcenter.heroku.com/articles/getting-started-with-nodejs) to setup my [personal landing page](http://www.giovannilodi.com).

_Sneak peek:_ having setup an Node + Express + Coffeescript task more than two times, and being DRY, _or lazy_, I've decided to put it in a repo. Stay tuned!

###Bower

They've done it again! After Bootstrap the Twitter team has released [Bower](http://bower.io/) _"A package manager for the web"_. It's the bundler or npm of your web packages. Smart! One of those things you say "How could I've lived without it?"

###Other Javascript stuff

* [Moment.js](http://momentjs.com/), a slim yet powerful library to manipulate time.
* I've played quite a lot with [Jade](http://jade-lang.com/), it's really cool, but not as flexible as I hope, _or maybe I need to dig more in the documentation…_. Anyway, I found this nice [Javascript Template Chooser](http://garann.github.io/template-chooser/).

###CSS Frameworks

I looked into alternatives to Bootstrap. Here's what I found:

* [Flat UI](http://designmodo.github.io/Flat-UI)
* [Gumby](http://gumbyframework.com/)
* [Pure](http://purecss.io/)
* [Skeleton](http://www.getskeleton.com/)
* [Foundation](http://foundation.zurb.com/)
* [Goldilocks](http://goldilocksapproach.com/)
* [IntuiCSS](http://inuitcss.com/)

###Jenkins

I've finally been able to plant the seed of the TDD and CI culture in my company. They bought me a Mac Mini, and I've set it up with Jenkins. It's been a bit painful, but really fun! And now we have the tests running at every push and two nightly builds, development and qa, distributed via TestFlight. _It's a shame I'm the only iOS dev who writes tests :(_

###Ruby

I had a quick, and not finished yet, blast at making a ruby gem. Enter [Swagify](mokagio.github.io/swagify/) a gem to add some your commands and scripts outputs. I'm not gonna talk too much about it here, as I don't consider the learning experience over (it never is btw).

###Readings

* [How to increase search traffic without being an asshole](http://mashable.com/2013/09/09/increase-search-traffic/).
* [An Insider’s View of Mobile-First Design: Don’t Make These Mistakes](http://www.wired.com/opinion/2013/09/designing-for-mobile-means-ditching-deeply-ingrained-pc-instincts/)
* [Why you should use zsh](http://fendrich.se/blog/2012/09/28/no/)

###Something funny

* [Sloppy UI](http://sloppyui.tumblr.com/) - It's all about the flaws in iOS 7 design
* [the_coding_love();](http://thecodinglove.com/) - Funny gifs to ease the dev life
* [Developers as Animals](http://developersasanimals.tumblr.com/)
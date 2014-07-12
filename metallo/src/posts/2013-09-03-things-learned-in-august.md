---
date: 2013-09-03
title: Some things I learned in August
tags:
- iOS
- Objective-C
- Ruby
- Layout
- CSS
- Open Source
slug: things-learned-in-august-2013
---

###iOS and Objective-C

Since `NSDecimalNumber` can be init from a string there's the risk it's gonna produce a NaN. To avoid this check for `[myDecimalNumber isEqualToNumber:[NSDecimalNumber notANumber]]`

[xcoder](https://github.com/rayh/xcoder) a Ruby gem to automate our Xcode project management.

###Ruby

As you know I have the -really good- habit of writing scripts to automate routine tasks in my work, mostly in Ruby. I naively used to check for arguments with `ARGV.include? "--some-option"`, until a workmate had a look at my code and surprisedly asked why Ruby didn't had an option parser library like <a href="http://docs.python.org/2/library/argparse.html#module-argparse">argparse</a> module in Python. Turns out it does. Meet the <a href="http://ruby-doc.org/stdlib-2.0/libdoc/optparse/rdoc/OptionParser.html">OptionParser</a> class.

Configure URI.extract to avoid unexpected surpirses. <a href="http://blog.apptamers.com/post/48613650042/uri-extract-incorrect-in-ruby-1-9-3">http://blog.apptamers.com/post/48613650042/uri-extract-incorrect-in-ruby-1-9-3</a>

[colorize](https://github.com/fazibear/colorize), gem to add color to Ruby scripts.

###Javascript

<a href="http://timeago.yarp.com/">timeago</a>, quick jQuery library to format datetimes in "xxx ago" strings.

###Layout and CSS

<a href="http://designmodo.github.io/Flat-UI/">FlatUI framework</a>

Their slow in definig standards, but sometimes the W3C is a good place where to find resources. <a href="http://www.w3.org/Style/Examples/007/fonts.en.html">Fonts usable in CSS</a>.

[Font Custom](http://fontcustom.com/) and [IcoMoon](http://icomoon.io/), resources to aggregate icons in a font file, to use as [font icons](http://css-tricks.com/examples/IconFont/). Or, why not, to speedup iOS development, as I'm doing in one project of mine I may write about soon: [MTFontIcon](https://github.com/mokagio/MTFontIcon).

###Interesting Readings

* [The Wooga approach to game prototyping](http://www.pocketgamer.biz/r/PG.Biz/Wooga+news/feature.asp?c=52660)
* [Techniques and Strategies for Data-driven design in Game Development](http://ai.eecs.umich.edu/soar/Classes/494/talks/Schumaker.pdf)
* [Some scaling tips from Dropbox](http://eranki.tumblr.com/post/27076431887/scaling-lessons-learned-at-dropbox-part-1)
* [A fun infographic about the startup world characters](https://www.udemy.com/blog/startup-ecosystem-infographic/)
* [How Twitter reached 143,199 Tweets per second](https://blog.twitter.com/2013/new-tweets-per-second-record-and-how)

###Tools

<a href="https://waffle.io/">waffle.io</a>, a shared kanban board for your projects on GitHub.

My workmates <a href="http://adamj.eu/">Adam Chainz</a> introduced me to the <a href="http://colemak.com/">Colemak</a> keyboard layout.
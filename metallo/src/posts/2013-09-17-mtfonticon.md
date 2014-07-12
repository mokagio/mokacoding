---
date: 2013-09-17
title: Bringing font icons in iOS with MTFontIcon
tags:
- iOS
- Objective-C
- Ruby
- Layout
- CSS
- Open Source
description: Introducing MTFontIcon, a CocoaPod library for iOS to improve application development efficiency by using font icons.
---

Let me introduce you one of my latests projects, on which I worked almost a month ago, but I'm both lazy and hyperactive when it comes to projects, so the blog post arrives only now...

###MTFontIcon

**MTFontIcons**, available as a [CocoaPod](cocoapods.org/?q=mtfonticon) and on [GitHub](https://github.com/mokagio/MTFontIcon), is a library that let's us use font-based icons in iOS application, speeding up the development and helping those poor developers that don't even know how to select the pen tool in Adobe Illustrator.

###The problem

Few people in our world are both great developers and skilled artist, my friend and ex-colleague [Tancredi](https://twitter.com/Liquidimage_) is one of those. For the rest of us mere mortals finding building a well crafted app is already a big task, and we don't have time to go through the [Nettus+](http://net.tutsplus.com/) Illustrator and Photoshop tutorials to learn how to make a nice icon set for our apps. We only speak code.

It would be really nice to have a way to iterate on the attributes of our icons and images quickly and without losing quality. Changing the color from #f0f0f0 to #f0dff1, making it 2pts wider, increasing the alpha of the shadow, without opening Illustrator, or worst waiting for the designer to put the assets on Dropobox. It would be nice to code all those things.

###The solution

The fact is our cousins from the web world already faced this problem, and solved in a really nice way! They've been using [Icon Fonts](http://css-tricks.com/examples/IconFont/) for a while, and they're really happy about them.
This technique is so powerful and popular that even the famous framework [Bootstrap](http://getbootstrap.com/) made by the guys at Twitter is using it. And there are plenty of resources only to get ready made stets of icons, or roll out our own font uploading the SVGs.

###How does it work?

Then why not using the same smartness in Objective-C? The MTFontIcon idea was born from the above mentioned rebel genious of Tancredi, while working on a prototype for a new concept at [Memrise](http://www.memrise.com). Unfortunately the idea protoyped wasn't that good, unlike the tech behind it.

The usage is simple:

1. Create a font with all your icons, using web tools like [IcoMoon](http://icomoon.io/app/).
2. Import the font in your app, and don't forget to updated the `Info.plist`.
3. Define the matchings between the names you want to use for your icons and the unicode character they have in the font.
4. Get an instance of `MTFontIconFactory` and use it to get as many `MTFontIconView`s as you want :)

Two minutes setup, two lines of code usage, twice as fast app UI development and polishing!

###Current problems and roadmap

Despite the `1.0.0` tag, MTFontIcon has still a long way to go before considering itself a mature and really useful project. Here's a list of things we could improve:

* Issues with ascendant and descendants, if you ever tried to use a custom font on iOS you know what I'm talking about. Otherwise read [this](http://stackoverflow.com/questions/7535498/uibutton-custom-font-vertical-alignment) and [this]().
* The library is coupled with [IcoMoon](http://icomoon.io/app/), at the moment you're better use that service, because all the font tunings (see above), are made on their font. Or you can fork the library and help me out.
* Using CoreText would be cleaner and more performant.
* Why not having a ruby script or gem to automate all the boring part of the process?

<hr/>

That's all folks. Working on MTFontIcon has been fun and stimulating. The library, and its authors, have still a long way to go, but I hope whoever will read the code will see the intention of making a top quality, well crafted, 2013 styled, piece of code.

If you're intereseted in font icons or in using MTFontIcon check out these resources: [Font Awesome](http://fortawesome.github.io/Font-Awesome/), 361 (as of version 3.2.1) awesome icons for you, [We Love Icon Fonts](http://weloveiconfonts.com/), a free and open source icon fonts hosting service, [Fontello](http://fontello.com/), an alternative to IcoMoon.
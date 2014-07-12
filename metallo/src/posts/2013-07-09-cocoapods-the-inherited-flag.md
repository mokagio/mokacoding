---
date: 2013-07-09
title: 'CocoaPods: the $(inherited) flag'
tags:
- CocoaPods
- iOS
- Xcode
slug: cocoapods-the-inherited-flag
description: A self memo on how to set the $(inherited) flag on a project using CocoaPods on Xcode.
---

I've done it a lot of times by now, but I keep forgetting it. So here's a quick post to commit it to memory!

If we have a project with the Tests target it can happen that after running `pod install` we get this message:

	[!] The target `MyProjectTests [Debug]` overrides the `FRAMEWORK_SEARCH_PATHS` build setting defined in `Pods/Pods-MyProjectTests.xcconfig'.
	- Use the `$(inherited)` flag, or
	- Remove the build settings from the target.

How can we "use the $(inherited) flag"? Where should we add it?

The `$(inherited)` flag is an flag we can pass to the linker and that <em>does some magic...</em>. I haven't been able to find a proper explanation for how <code>$(inherited)</code> works, although it's easy to guess from the name.

Being a linker flag we can add it in our target Build Settings &gt; Other Linker Flags section.

<a href="http://amokafullofstuff.files.wordpress.com/2013/07/screen-shot-2013-07-10-at-00-16-36.png"><img class="size-medium wp-image-164 aligncenter" alt="Screen Shot 2013-07-10 at 00.16.36" src="http://amokafullofstuff.files.wordpress.com/2013/07/screen-shot-2013-07-10-at-00-16-36.png?w=300" width="300" height="114" /></a>

That's all. I feel better now that I've put this piece of memory in the external storage of my brain that is the internet. And I hope it may help someone else too.

---
layout: post
title: How To Fix Fabric Crashing On Startup When Installed Via CocoaPods
description: If you are experiencing crashes with a version of Fabric and Crashlytics installed via CocoaPods chances are you are missing required information in the Info.plist. This post shows how to solve this issue.
tags:
- Espresso
- iOS
---

**TL;DR**

If the version of the Fabric and Crashlytics SDK installed via CocoaPods is
crashing on you throwing a `SIGABRT` like this:

![Screenshot of the crash from within Xcode](https://s3.amazonaws.com/mokacoding/2016-01-28-fabric-crashlytics-crash.png)

Then chances are you forgot to add the information Fabric needs to your app's `Info.plist`.

Add this code to your `Info.plist`, clean and run again.

```plist
<key>Fabric</key>
<dict>
	<key>APIKey</key>
	<string>YOUR_API_KEY</string>
	<key>Kits</key>
	<array>
		<dict>
			<key>KitInfo</key>
			<dict/>
			<key>KitName</key>
			<string>Crashlytics</string>
		</dict>
	</array>
</dict>
```

![The Fabric section of the Info.plist from the editor in Xcode](https://s3.amazonaws.com/mokacoding/2016-01-28-fabric-crashlytics-info-plist.png)

**TS;WR**

I recently spent a too long amount of time puzzled by the [Fabric](https://fabric.io)
iOS SDK crashing at startup for no apparent reason.

The line of code crashing was taken from their setup guide, and the only Fabric related instruction I added in the project yet. The only difference between the guide and mine setup was that I used [CocoaPods](https://cocoapods.org/), which is listed as one of the supported methods of installation.

Since their SDK is closed source, _who knows what kind of evil user tracking
code is in there_, I had no way to get more information on the crash.

The solution to my issue came from my friend and fellow developer [Vlas Voloshin](https://twitter.com/argentumko).

Vlas was able to look at the problem from a higher point of focus than mine,
and rightly point out that Fabric and Crashlytics need an API key to work, and that I wasn't setting it anywhere in the app.

_Once somebody tells you it sounds obvious doesn't it?_ 😳

When you setup Fabric using their annoying Mac app, the `Info.plist` is automatically updated with the required information. When using a less magic approach the file is not updated, so you have to do it yourself.

Many thanks to Vlas for, once again, helping me out realising the obvious.

_Leave the codebase better than you found it._


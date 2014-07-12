---
date: 2013-09-16
title: A workaround to Xcode 5 GM crash on app submission
tags:
- Xcode
- App Store
- Bugs
slug: xcode5-crash-on-submission
description: A workaround for the unusual crash of Xcode 5 GM during the App Store submission process.
---
I just finished writing this post, and I realized is just about me complaining trying to sound funny. So here's, frontloaded, the important stuff.

Apparently Xcode 5 GM crashed on some of us during the App Store submission process. Before even starting it. How annoying.

The workaround I found relies on bypassing Xcode for the submission process.

####Step 1

Make sure all the provisioning profiles and code signing are set properly

####Step 2

Open your Terminal and generate the `.ipa` yourself, with the help of [shenzhen](https://github.com/nomad/shenzhen).

	cd my/ready/to/be/submitter/ios/project
	ipa build -c Release

####Step 3

Upload the app through Application Loader.

####Step 4

Find a tv series to start watching while waiting for your app to be reviewed.

That's all. It took me an embarrassing long while to figure this out, I hope to be helping some fellow developer with this post.

Below the full thing.

<hr/>

Every now and then in the lifecycle of an iOS project it comes the day when you have to submit an update, or even worst touch the provisioning profiles. When that day comes, it's better if it's a Monday, because you don't want to ruin yourself the weekend. And it's also better if you have chamomile in your cup instead of coffee.

###Submit your iOS7 apps today

![Submit today](http://mokacoding.s3.amazonaws.com/2013-09-16-submit-today.jpg)

On the 10th of September Apple sent an email to their developers, "Submit your iOS7 apps today" they said. Up to that point we couldn't submit apps made with the iOS7 SDK, as written somewhere in the Xcode 5 Developer Preview release notes. But that day the iOS7 GM and Xcode 5 GM where released, and the run to submit started.

![Use Xcode 5 GM](http://mokacoding.s3.amazonaws.com/2013-09-16-use-xcode5.jpg)

In their beautiful styled [iOS7 developer page](https://developer.apple.com/ios7/) they explained everything. If you follow the link to the [App Distribution Guide](https://developer.apple.com/library/prerelease/ios/documentation/IDEs/Conceptual/AppDistributionGuide/Introduction/Introduction.html) in the bottom of the page you will have a funny surprise. The link goes to the previous version documentation, and our Apple engineers forgot to add a link to the new version.

![Missing link](http://mokacoding.s3.amazonaws.com/2013-09-16-missing-link.jpg)

I'm sure everything is gonna be fine, Xcode is such a reliable IDE, and the Apple guys are known for the quality of the products they give to their developers. Let's go!

###The tragic message

When clicking on "Validate" or "Distribute" from the organizer, no matter how may times I refreshed my Accounts in the Preferences menu this is what I got

![The terrible dialog](http://mokacoding.s3.amazonaws.com/2013-09-16-the-terrible-dialog.jpg)

And guess what? Both those buttons resulted in Xcode crashing, right there, with no explanation, no progress bar, nothing, Boom!

Out of curiosity I opened the crash log that got generated and…

	Crashed Thread:  0  Dispatch queue: com.apple.main-thread
	
	Exception Type:  EXC_BAD_ACCESS (SIGSEGV)
	Exception Codes: EXC_I386_GPFLT
	
Whenever I get an `EXC_BAD_ACCESS (SIGSEGV)` I feel like punching myself in the face, it's a memory issue, and I must have been really dumb to produce something like that in the ARC era.

But let's not waste time complaining about those things, risking to be kicked out of the dev program, and look for a solution.

###The workaround

What's the place where all the developers go when in trouble? No it's not church, it's [StackOverflow](stackoverflow.com)! There I found [someone with the same problem](http://stackoverflow.com/questions/18748779/xcode5-gm-crashes-no-identities-are-available-for-signing-then-crash/), suggesting to use Application Loader to upload the app.

I never used it before, but I was faced with a problem straightaway. Application Loader need an `.ipa`, which we can generate only through the Organizer in Xcode.

_"which we can generate only through the Organizer in Xcode."_. Are you sure about it? 

Actually `xcodebuild`, Xcode CLI, let us build ipas, in a very complex way. `xctool` buy the Facebook iOS team makes the task easier, but it the usual suspect, good guy [Mattt](https://github.com/mattt) that has the real solution for that. With his gem [shenzhen](https://github.com/nomad/shenzhen) we can build an ipa from command line without spending too much time specifing options or reading through the `--help` guide.

	ipa build -c Release
	
That's all we need to generate our `.ipa`.

Once we have our package we can send it to the Apples servers through Application Loader, bypassing Organizer and the frustrating crash. Smart!

<br/>
That's all folks. I'm a bit disappointed by the fact that such an issue is leaked on a GM, when we, some of us at least, spend so much time unit testing our apps, being patient with the QA guys, and taking all the possible measures to make sure everything works as expected. But nobody's perfect, and every now and then hacking stuff is fun, so no big deal.

Happy coding!
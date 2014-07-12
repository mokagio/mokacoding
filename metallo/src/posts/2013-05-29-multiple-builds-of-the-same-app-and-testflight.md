---
date: 2013-05-29
title: Multiple builds of the same app and TestFlight
tags:
- automation
- development
- testflight
- xcode
slug: testflight-multiple-builds
description: How to distribute multiple builds of your iOS app, such as stable, QA and development builds, via TestFlight.
---
<h3>The Multiple Builds Dream</h3>

<p>Working in <a href="http://www.memrise.com">Memrise</a> on <a href="http://www.catacademy.com/">CatAcademy</a> I've been massively using <a href="https://testflightapp.com">TestFlight</a> to test new features before releasing the next versions of the app. One thing that always annoyed me was the fact that my development version overrode the release one, or that I couldn't keep a "stable" build and a "development" build on my device at the same time.</p>

<p>After attending the <a href="https://developers.facebook.com/events/mobiledevcon/london/">Facebook Mobile DevCon 2013</a> in London, where the <a href="https://www.youtube.com/watch?feature=player_embedded&amp;v=77aUV6ks4Ks">talk from Alan Cannistraro</a> on how Facebook made their iOS app I realized that having multiple builds of the same app was possible. But how to do it?</p>

<p>I did some research and found <a href="http://blog.chrismiles.info/2011/04/ios-dev-beta-production-builds.html">this post</a>, which had almost all the info I need on how to setup my multiple builds infrastructure. There's no point in me copy-pasting what's written there, besides I'm sure 99.9% of you readers already opened the link in a new tab.</p>

<p>The post is pretty old, so here's an updated screenshot of the Build Settings editor.</p>

<a href="http://amokafullofstuff.files.wordpress.com/2013/05/screen-shot-2013-05-29-at-22-05-48.png"><img src="http://amokafullofstuff.files.wordpress.com/2013/05/screen-shot-2013-05-29-at-22-05-48.png?w=300" alt="Screen Shot 2013-05-29 at 22.05.48" width="300" height="187" class="alignnone size-medium wp-image-100" /></a>

<p>If you follow the instructions and run the app on the simulator or on the device, you'll see the new development app appearing next to the release one, as expected.</p>

<p>This is pretty handy to go around with the two versions of the app and to some user testing with the friends, but guess what? It doesn't work with TestFlight! But fear not, there are only two other steps to make before reaching the goal.</p>

<h3>Making a Development Archive</h3>

<p>First problem: when we archive the app the Release configuration is used. Changing this option is pretty easy through the "Edit Scheme…" menu, but wait a second! If we change now the Build Configuration for the archive action from Release to Debug, we'll have to change it back once we're going to publish on the App Store.
Better creating a new <a href="http://developer.apple.com/library/ios/#featuredarticles/XcodeConcepts/Concept-Schemes.html" title="Xcode Scheme" target="_blank">Scheme</a> and change the configuration in that one.</p>

<p>"Changing the Scheme every time we want to submit it just as annoying as editing it". Fair enough. But not really… Switching Scheme requires 2 clicks, while editing it at least 6. :P No, seriously switching Scheme is something we can <strong>easily automate</strong>, using xcodebuild or <a href="https://github.com/facebook/xctool">xctool</a> and a couple of lines in your favourite scripting language.</p>

<h3>Making it work on TestFlight</h3>

<p>All right! Now we're finally able to archive our development version of the app and upload it on TestFlight, maybe through the TestFlight App which is nice and fast. But if we try to do it this is the result:</p>

>The provisioning profile is made for distribution builds but your app is built for development. Please select a valid development identity to continue.

<p>Don't panic! The message gives us a tip already on how to solve the issue, we just need another Provisioning Profile! Select Development when creating the new profile and use the AppID of the "original" app. This last point surprised me, but I think it may have something to do with the sort of hierarchy structure the bundle ids have.</p>

<p>Once your Provisioning Profile is ready update the certificates list in Xcode, through the Organizer window, and proceed to Archive the app. Now when you'll upload the archive with the TestFlight App the new development certificate will appear.</p>

<p>Here we go!</p>

<h3>Further Steps</h3>

<ul>
<li>Add other Build Configurations, such as Testing, and other options, for example to have different icons for the different builds.</li>
<li>Manage the archive operation with xctool.</li>
<li>Automate even further using the TestFlight Upload APIs.</li>
</ul>

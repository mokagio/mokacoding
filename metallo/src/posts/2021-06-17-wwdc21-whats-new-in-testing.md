---
title: "WWDC21: What's New in Testing"
description: "A roundup of the testing-related new features announced at WWDC 2021. Including Xcode Cloud, how to test code using async/await, the new XCTExpectFailure and addTearDownBlock APIs, and the new Test Repetition configuration in Test Plans."
og_description: Roundup of testing related new features announced at WWDC21
tags:
- Testing
- XCTest
- Swift
- Talks
# If none provided, the site will use a default one
# og_image: https://s3.amazonaws.com/mokacoding/...
# The date is picked from the file name, but you can use this to override it
# date:
---

As a testing enthusiast, I'm always waiting for a "What's New in Testing" session at WWDC, like the ones from [2017](https://developer.apple.com/videos/play/wwdc2017/409/) and [2018](https://developer.apple.com/videos/play/wwdc2018/403/).
This year I was even keener to learn what was new because of the upcoming launch of my book [Test-Driven Development in Swift](https://tddinswift.com) on July 11th.

Since there was no "What's New in Testing" talk at WWDC21, I thought I'd make one for the WWDC themed [Melbourne Cocoaheads Meetup](https://melbournecocoaheads.com/) last week.
You can see the live stream recording [here](https://youtu.be/BIL3GvBFatE?t=2807).
I recorded an in-case-of-emergency version beforehand, which I embedded below alongside the slides because it has better video quality.
In the same meetup, [Jarrod Robins](https://twitter.com/jarrodrobins) gave a hilarious [iOS and macOS new features talk](https://youtu.be/BIL3GvBFatE?t=742) which I recommend too.

## Video
<!-- YouTube embed code -->
<!-- Thanks https://jameshfisher.com/2017/08/30/how-do-i-make-a-full-width-iframe/ for the aspect-ratio with YouTube iframe code -->
<div>
  <div style="position:relative;padding-top:56.25%;">
   <iframe style="position:absolute;top:0;left:0;width:100%;height:100%;" src="https://www.youtube-nocookie.com/embed/k3PWUbHbx-4" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
  </div>
</div>

## Slides
<!-- SpeakerDeck embed code -->
<script async class="speakerdeck-embed" data-id="b9be478e46f2450098b0a7422807f51a" data-ratio="1.77777777777778" src="//speakerdeck.com/assets/embed.js"></script>

## What's New in Testing

The biggest testing news was Apple's new **[Xcode Cloud](https://developer.apple.com/documentation/xcode/xcode-cloud)** service, a Continuous Integration service fully integrated with Xcode and App Store Connect.

Managing CI for Swift apps has historically been tricky because of the hardware constraint that builds need to run on a Mac.
There are existing products like [Bitrise](https://www.bitrise.io/) and [TravisCI](https://docs.travis-ci.com/user/reference/osx/) offer managed solutions, but who better than Apple to provide a managed environment on Apple hardware?

As of this writing, Xcode Cloud is in beta, and I haven't gotten an invite yet, so it's hard to give a concrete opinion.
From what we can understand from Apple's demos at WWDC, I think this will be ** a solid solution for indie developers and small teams that don't have the time or know-how to manage their CI infrastructure**.

Another huge announcement, albeit not really a piece of news since Swift development happens [in the open](https://swift.org/community/), was the introduction of the **async/await pattern** for asynchronous operations and concurrency.
Not only async/await makes writing async code straightforward but also testing it.
Check out [this post](https://mokacoding.com/blog/how-to-test-async-await-code-in-swift/) for more details.

XCTest got two new shiny APIs for us to play with.
**`XCTExpectFailure`** allows you to expect tests to fail.
I encourage you to use this API only in extreme cases, like during an extensive rewrite that breaks some code areas.
Do not use it to avoid dealing with tests that are broken or flaky.
`XCTExpectFailure` is already available in Xcode 12.5; you don't need to wait for Xcode 13 to use it.
You can find the WWDC session [here](https://developer.apple.com/videos/play/wwdc2021/10207/) and the docs [here](https://developer.apple.com/documentation/xctest/3726077-xctexpectfailure).

Another new handy method is **[`addTearDownBlock`](https://developer.apple.com/documentation/xctest/xctestcase/3815521-addteardownblock)** with which you can push code to execute after a test finishes into a LIFO stack.

A new testing feature coming with Xcode 13 is the addition of a **Test Repetition** configuration to Test Plans.
There are four test repetition modes:

- _None_. Do not repeat the tests
- _Until Failure_. Runs the tests until one fails, up to three times. Useful to discover flaky tests.
- _Retry on Failure_. Will retry the tests that failed up to three times. Helpful to work around flaky tests that you haven't had the time to fix yet.
- _Up Until Maximum Repetition_. Will run the tests three times (the number doesn't seem configurable yet) and report the success ratio. Useful to gauge the stability of your test suite.

One feature unrelated to testing that I'm super excited about is **Vim key bindings** in Xcode.
Fun fact, I'm told that Vim keybinding support was requested with Radar 3716281 in July 2004, although I couldn't find a link to that radar.

I've been a Vim user for a long time, and I'm writing this post with Vim.
Once you get over the initial learning curve, Vim's _modal editing_ will make you super efficient at manipulating text.
It's great to see this powerful text editing capability being added to Xcode.

I'm so excited about Vim key bindings that I'm considering putting together [a course](https://mokacoding.com/xcode-heart-vim) about it.
Head over [here](https://mokacoding.com/xcode-heart-vim) to learn more and register your interest.

---

WWDC had lots of exciting testing news, and more little nuggets can be found in the [Xcode 13 release notes](https://developer.apple.com/documentation/xcode-release-notes/xcode-13-beta-release-notes) —even though testing is at the very bottom.
What was your favorite news?
I'd love to hear from you!
Leave a comment below or get in touch on Twitter at [@mokagio](https://twitter.com/mokagio).

And, of course, don't forget to check out [Test-Driven Development in Swift](https://tddinswift.com) if you want to learn more about testing Swift applications.

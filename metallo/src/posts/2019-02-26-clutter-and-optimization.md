---
title: The value of decluttering and optimizing your software
description: "Digital minimalists believe that clutter is costly and optimization is important. Let me show you how these ideas apply to software development as well."
tags:
- Books
- Productivity
- Software Design
---

In his book [Digital Minimalism](https://geni.us/7HNOJAz) Cal Newport defines a new _philosophy of technology_ that aims to help people living better lives by having a better relationship with the apps and devices they use. Two of the digital minimalism principles are clutter is costly, and optimization is important. These ideas translate to software development as well, and applying them can bring significant improvements in our day to day work.

## Clutter is costly

Cal Newport argues that by mindlessly signing up for every new service and using every new app you clutter your digital life. The overwhelming number of technologies you use dilutes the benefits that the few ones actually valuable to you could provide. Clutter is costly in software development too, and you should avoid it as much as possible.

Strive to keep your functions short, and your types and objects focused on [doing only one thing](https://en.wikipedia.org/wiki/Single_responsibility_principle). Take into account the mental overhead required to read and understand the code. The more clutter, the harder the code is to parse, which makes it harder and slower to work with. For everything you write consider its _local reasoning_ cost, ideally when you look at the code, right in front of you, you shouldn't "have to think about how the rest of your code interacts with that one function" as [Apple engineers put it](https://developer.apple.com/videos/play/wwdc2016/419/)

Every third party dependency comes with a hidden cost to be kept up to date, and the possibility of introducing bugs. Don't get me wrong, libraries and frameworks are often fundamental in building good software. After all, you should be focusing on solving your domain problems, not in reinventing the wheel. I just want you to be aware of the tradeoff you're making when you offload the responsibility to get something done to code you don't control. Remember the [`left-pad` incident](https://blog.npmjs.org/post/141577284765/kik-left-pad-and-npm), when a single module being removed from npm broke the majority of the frameworks in the JavaScript ecosystem.

Care with dependencies should not restrict to third-party code. Always try to keep the number of domain concepts a single object depends upon in check. Clutter makes software less flexible, say you want to extract part of your logic in a dedicated module so that you can work on it in isolation and with a faster feedback cycle. If your code is not well isolated, you'll have a lot of work in front of you to extract it, often carrying along domain concepts unrelated with what your original code is concerned.

Fight clutter in your product as well as your code. Apps that try to do too much, have all the features, please all the users, end up being bloated and unappealing instead. Don't be afraid to make trade-offs, as long as they are intentional. Whenever approached to build a new feature make sure its value to the users is made clear. To question functionalities is not the sign of a lazy developer, but of a thoughtful one, committed to the success of the product. Ask whether the assumptions behind the change have been validated. Suggest using a mock-up or paper prototype on the people in the office to try it out first. People will pay for products that solve real problems, focus on that.

Be ruthless in removing unused code. Develop the discipline to clean up after yourself. Unused code and out of date comments are the ultimate clutter in a codebase, they make reading, building, and working with it harder. If management is not open to the idea of spending time to clean up after shipping a feature, explain to them that its a matter of hygiene. Like you wouldn't leave your kitchen dirty after cooking, or the house messy before guests arrive, so the codebase should always be kept clutter-free, in order not to rot. 

## Optimization is important

The digital minimalists optimize their interactions with technology to make the most out of them, often going outside the default patterns of usage. For example, instead of using Facebook to stay up to date with the news, they might subscribe to a few curated newsletters, store the articles they care about in [Pocket](https://getpocket.com) or [Instapaper](https://www.instapaper.com/) to have an ads-free version focused on readability, and consume them over coffee during the weekend.

Like digital minimalists with their services, we software developers should not be content just with getting things done, but always seek to make the most of our tools.

Optimizing how you use your IDE or text editor will remove friction between your thoughts and their materialization on the screen, it will save you time and energy. Look into the menus to discover new features, and learn the keyboard shortcuts -[check this out if you use Xcode](http://xcodetips.com/). Most tools support plugins, browse their catalog, and you'll find all sorts of useful things to improve your workflow.

IDEs and text editors are not the only tools of a software developer. Become intimate with the standard library of the programming languages you use, as well as the documentation of the frameworks on top of them. Never assume that the way you are doing something is the best one. You don't know what you don't know, so take the time to dig deeper. A great way to ramp up your knowledge of any given language or framework is to read the documentation for every class or method you haven't used yet. This practice is admittedly time-consuming at first, but as time goes, you'll become familiar with it and need to do this less often. You'll learn a lot along the way. With open source libraries, you can also look at how they implemented things to learn tricks and best practices.

Aim to master version control as well. Learning to use Git will make it much easier for you to write software in incremental stages, without ever fearing to miss your work in progress. Because we collaborate on the code being able to make collaboration easier by having small commits and pull requests will optimize the speed at which you can get feedback on your work and eventually merge it.

Tune your compilation and test phases, so they are as fast as possible. You want to the feedback tests and compiler provide to be timely. Staring at a progress bar is a challenge to anyone's self-control to stay focused on the task at hand instead of going off to social media. So don't make it harder on yourself to do your best work, don't let your builds and tests become slow.

<p style="text-align: center;">***</p>

Take a leaf from the digital minimalist playbook. Reduce clutter to avoid paying its mental overhead price. Optimize how you use your tools and workflows to get feedback fast, and get things done even faster. Less is more, aim to be better, not bigger.

### Related Articles

- [How To Sharpen Your Software Developer Tools](https://www.mokacoding.com/blog/tools-sharpening)
- [How To Become Drastically Faster At Using The Terminal](https://www.mokacoding.com/blog/terminal-aliases)
- [Keep Your Bench Clean](https://www.mokacoding.com/blog/keep-your-bench-clean/)

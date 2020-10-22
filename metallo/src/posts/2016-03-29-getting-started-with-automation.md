---
layout: post
title: Getting Started With Automation
description: A collection of tips to get you started with workflow automation, increase productivity, and save time.
tags:
- Automation
---

In the past months I worked with a number of team setting up continuous integration and delivery infrastructures, and helping with their all around automation and testing. A common thing that I've seen is that while we all agree that having automation is important is not always easy to know where to start, and one could feel overwhelmed.

In my opinion there are two places where to start looking for automation candidates in your development work flow: mindless repetitive things, and actions that require multiple steps in which we might forget one, or make a mistake in one point of the process that would propagate to all the others.

Mindless repetitive things are the automation low hanging fruits because by being mindless they are the easiest to describe in a script for a machine to execute, and by being repetitive you will get a lot of value by automating them, as you will run your script multiple times.

The possible gain in automating tasks that require multiple steps is more subtle, but also bigger. Tasks that require multiple steps are harder to remember, usually need some kind of documentation or checklist, and the making a mistake in one step breaks all the following ones. If instead of relying on your memory or a checklist that might or might not be up to date you describe the process in an automation script not only you make sure that each step will be executed with the right inputs and in the right order, but also create a documentation that is live and always up to date.

## Example of Automation in iOS Development

#### Bumping the version and build number of the project, and eventually commit the change

These two action are always the same, and they consist in a simple edit to a file, which can be easily executed by a script which can then take care of calling git to commit the change.

#### Generating code coverage reports

If you work with enterprise clients chances are that they'll require you to produce documentation regarding your test coverage. Tools like [slather](https://github.com/SlatherOrg/slather) can be used to generate a report based on Xcode code coverage. You can even go a step further and manipulate the gathered data into a pdf and automatically send it via email.

#### Running unit and acceptance test

To generate test coverage reports you need to have run the tests first, and its always best to run them as a pre-step before every code coverage data generation. Running your tests via a script is [very simple](https://mokacoding.com/blog/running-tests-from-the-terminal/), and once you have it in place hooking up a CI system will be as easy as configuring it to run your script.

#### Building, archiving, and exporting your app for distribution

This is a good example of a process that requires multiple steps, and in which an error in one step might compromise the next one. Stop manually changing the code signing identity and provisioning profile, waiting for the archive action to complete and its result window to appear, and then click the export button. Define which configuration, identity and provisioning profile to use in a script, and let it string together the steps needed to produce an ipa.

#### Distributing your app to betatesters

Uploading a build to a beta distribution platform usually requires using an app provided by them, or going on their website. Chances are your provider has APIs that you can use to upload the build from a script instead, so that you only have to press one button.

The nice thing about this is that it can be added as an extra step to the previous one, so that you can build an ipa and distribute it all in one go.

#### Environment Bootstrap

Another example of processes that require multiple steps and for which the documentation might not be up to date is setting up the development environment after a fresh clone of the repository. You might be needing extra tool installable via [Homebrew](http://brew.sh), [Ruby gems](https://mokacoding.com/blog/ruby-for-ios-developers-bundler/), etc., fetching dependencies. It is easy to write a script that checks for every required tools, installing them when possible, and calls any other command with multiple parameters required to bootstrap the dev environment.

---

These are only some ideas to help you get started automating your workflow and increasing your productivity. Ideally everything that can be automated should be automated, just pick some low hanging fruit and start gaining back time.

Another cool thing is that automation works as effectively for individuals as it does for teams, so you can practice by yourself and then introduce your automation scripts to the rest of the team when you think they're good enough to share.

I'd love to hear from you regarding what you have automated and what to plan to automate, you can leave a comment below or get in touch on Twitter [@mokagio](https://twitter.com/mokagio).

_Leave the codebase better than you found it._

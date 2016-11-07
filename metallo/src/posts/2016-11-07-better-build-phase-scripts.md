---
layout: post
title: Better Xcode Run Script Build Phases
description: 'Practical tips to write "Run Script" build phases in Xcode.'
tags:
  - Xcode
---

Xcode offers the possibility to run user defined code as part of the build
process using the "Run Script Phase" in the "Build Phases" section.

<!-- Manually editing the HTML here because the image is small and we don't want to stretch it -->
<img src="https://s3.amazonaws.com/mokacoding/2016-11-07-run-script-menu.png" alt="Build Phase Menu to add a Run Script Phase" style=" width: 300px;" />

This is a very handy feature as it allows us to do things like:

- [Dynamically set the version and build number based on external parameters](http://www.mokacoding.com/blog/automatic-xcode-versioning-with-git/), e.g. commits count
- Load the settings bundle with options debug options to change the environment
- Watermark the icon with the build number on debug builds

As well as that, third party tools like Carthage and CocoaPods rely on build
phases scripts for their Xcode integration.

Unfortunately the interface to manipulate these scripts that Xcode provides us
is not the most usable 😞.

First of all, writing and editing a script in a text area this size is not
ideal. Specially when, as of Xcode 8.2 beta 1 the text area cannot be resized.

![Run Script Text Area](https://s3.amazonaws.com/mokacoding/2016-11-07-run-script-text-area.png)

But even worse is the way the scripts are tracked in the project file: all in
one line! How is anyone supposed to understand a diff like this?!

![One line script](https://s3.amazonaws.com/mokacoding/2016-11-07-one-line-script.png)

This makes it hard read the script during code reviews when it is added the
first time as well as when changes are made to it.

![One line script diff](https://s3.amazonaws.com/mokacoding/2016-11-07-one-line-script-diff.png)

_Can you spot the difference?_

For developers working in teams the readability and maintainability of the code
is of top priority, and this is true for the code itself as well as the way its
changes are tracked in the source control.

On top of that, if you've been using Xcode for a while you'll know how annoying
it is to resolve conflicts on the `project.pbxproj` file, so any technique that
can make changes on that file less likely is very valuable.

Let's see how we can make working and maintaining build phase scripts better
with a few simple steps.

## Extract the script

The single most effective action you can take to improve your build scripts is
to extract them into their own files. If you bring anything home from this
post I hope this is it. Extract your scripts.

The best way to do this is to create a folder in your project's root called
"Build-Phases" and to create a file `my-script.sh` into it.

You can then make your script executable by [changing its
permission](https://bash.cyberciti.biz/guide/Setting_up_permissions_on_a_script)
using this command in the terminal:

```
chmod u+x Build-Phases/my-script.sh
```

Finally you can replace the script content in the Xcode build phase editor with
a command to execute your script:

`$SRCROOT/Build-Phases/set-build-number`

![Extracted run script](https://s3.amazonaws.com/mokacoding/2016-11-07-extracted-run-script.png)

Now when you and your teammates will edit the file changing will be the script
itself, not the `project.pbxproj`, making the diff way easier to understand:

![Better diff](https://s3.amazonaws.com/mokacoding/2016-11-07-better-diff.png)

## Name your scripts

Xcode will name every new run script phase as "Run Script", but that can be
quite confusing when you have more than one. Double click on the "Run Script"
header to reveal a text field you can use to rename your phase.

## Group multiple scripts in a master script

As the project grows you'll likely need to have more then one user defined
build phase script. A way to keep this tidy and to keep avoiding changes to the
`project.pbxproj` file is to group your many scripts under a "master script".

The idea is to have a single script invocation in Xcode, calling a script that
will then take care of executing the single scripts.

This technique will help you grow your script, change their order, etc. in a
tidy and understandable way.

The only gotcha is that all your scripts need to be able run in between any of
the predefined build phases, in which case you should place them individually
in the order they need to be.

## Report errors and warnings

You can make your scripts output compilation errors or warnings the same way
Xcode does. I learnt this a while ago [from this
post](http://briksoftware.com/blog/?p=120).

```
echo "error: Your error message"
echo "warning: Your warning message"
```

This ability is quite handy, it allows you to communicate with the other
developers using the script. You can use this for example to fail the build
when required software is missing.

## Ensure required tools are available

A common use of run script build phases is to integrate third party tools into the build process, but what happens when such tools are not present in the developer's machine? It's a good idea to fail the build and inform them that their setup is incomplete. This is how you can do it:

```bash
set -e

if ! which <your tool> > /dev/null; then
  echo "error: <your tool> is missing"
  exit 1
fi
```

For example if you want to make sure new developers have SwiftLint installed, you can use this script:

```bash
set -e

if ! which swiftlint > /dev/null; then
  echo "error: SwiftLint is not installed. Vistit http://github.com/realm/SwiftLint to learn more."
  exit 1
fi

swiftlint
```

Or if you feel that failing the build is too harsh, you can just throw a warning:

```bash
set -e

if ! which swiftlint > /dev/null; then
  echo "warning: SwiftLint is not installed. Vistit http://github.com/realm/SwiftLint to learn more."
else
  swiftlint
fi
```

## Debug tips

As with all software, run scripts phases don't usually come out right at the
first try (_at least not for me_). Here's two debugging tips:

Make sure the "Show environment variables in build log" checkbox is active.
This will make Xcode print all the environment variables values if a build
fails, and you'll be able to verify whether the assumption you made on those
are correct or not.

![Show environment variables](https://s3.amazonaws.com/mokacoding/2016-11-07-show-env-vars.png)

Add `set -x` at the start of the script to make the shell print all the
commands it executes. This is very helpful to find out at which point of the
script failures occur.

And remember that you can use `echo "error: message"` and `echo "warning:
message"` to log extra information to help you debug your issues in the script.

---

Run Script Build Phases are very useful and can help you automate a number of
tasks and improve the overall quality of your codebase.

I hope this post provided you with useful tips on how to write better scripts,
if you have questions, have found an error, or need help setting up your run
scripts feel free to leave a comment below, or get in touch on Twitter
[@mokagio](https://twitter.com/mokagio).

_Leave the codebase better than you found it._

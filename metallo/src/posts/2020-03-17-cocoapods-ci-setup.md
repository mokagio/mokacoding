---
title: How to use CocoaPods as a CLI tools manager
description: 'CocoaPods can be configured to only resolve and download dependencies, making it a great manager for vendored CLI tools'
tags:
- iOS
- CocoaPods
- Tooling
og_image: "https://s3.amazonaws.com/mokacoding/2019-04-09-open-graph-cover.png"
---

**TL;DR** You can configure [CocoaPods](https://cocoapods.org/) to not integrate with your Xcode project and use it to only resolve and fetch your dependencies.
This is handy to control the version of the CLI tools you use in an iOS project that already has a Ruby setup but that uses Carthage or SPM for dependency management.

### `Gemfile`

```ruby
# frozen_string_literal: true

source 'https://rubygems.org'

gem 'cocoapods', '~> 1.9.0'
```

### `Podfile`

```ruby
# This Podfile is configured to not integrate with an xcproject, because the
# only thing we are interested in is fetching CLI tools
install! 'cocoapods',
  integrate_targets: false,
  skip_pods_project_generation: true

platform :ios, '13.0'

pod 'SwiftFormat/CLI', '~> 0.40'
pod 'SwiftLint', '~> 0.38'
```

Then, you can use the tools via the binaries pulled by CocoaPods, like:

```
./Pods/SwiftLint/swiftlint
```

You can see the full setup in action in [this example repo](https://github.com/mokagio/cli-pods/).

---

Whether you like CocoaPods or not, there's little arguing about how refined of a dependency manager it is.

I know a lot of people don't like to use CocoaPods because it adds a lot of stuff to a project and it's a rather opinionated tool.

Recently, I discovered you can use CocoaPods to manage the version of the CLI tools you use in your projects, as long as they are distributed via CocoaPods.

## Why bother?

Strictly controlling the tools the project uses ensures every developer and machine working with the repo will use the same versions and get the same behaviour.
This provides a more consistent experience, reducing the occurrence of "but it works on my machine" kind of issues.

## How do do it

In order to use CocoaPods to only resolve and fetch dependencies, you need to configure it to avoid the creation of dedicated targets, workspace, and integration in your project.

```ruby
install! 'cocoapods',
  integrate_targets: false,
  skip_pods_project_generation: true
```

Once your `Podfile` is setup, you'll need to run `pod install` as usual.
You'll get a warning message like:

```
[!] The abstract target Pods is not inherited by a concrete target, so the following dependencies won't make it into any targets in your project:
Skipping User Project Integration
    - SwiftFormat/CLI (~> 0.40)
    - SwiftLint (~> 0.38)
```

That shouldn't be surprising, we intentionally told CocoaPods we don't want those pods to make it into any of our project's targets.

Now you have those CLI tools at your disposal in the repo, each located in the Pods folder.
For example, to run the downloaded version of SwiftLint, you should use:

```
./Pods/SwiftLint/swiftlint
```

You can see this setup in action in this [example repo](https://github.com/mokagio/cli-pods/) which uses a GitHub workflow to run [SwiftLint](https://github.com/realm/SwiftLint) and [SwiftFormat](https://github.com/nicklockwood/SwiftFormat) fetched via CocoaPods.

## A note on version control

The CLI tools you can download via CocoaPods come in the form of binary files.
Git is designed to manage changes in text files, not binaries.
Since it's not able to parse a diff on binary files, Git stores each full version of a binary file in the history.
This means that if you plan to update your tools often or if you are working with tools that have a non trivial size, storing them in version control will end up making your repository quite heavy.

If you want to keep your repository lean, there are two options. You can ignore the `Pods/` folder or you can store the binaries using [Git LFS](https://git-lfs.github.com/).

Ignoring `Pods/` results in a simpler setup, but you'll have to re-run `pod install` on every checkout where the version of the tool has changed to be sure you are using the expected one, or add scripts that check that for you.
On CI, you can work around this issue using a cache for your pods.
Using Git LFS adds a bit of management overhead but you'll only build to build your tools once per update, and you're guaranteed to be able to fetch them even if something happens to their source on the CocoaPods side.

---

Before adopting this approach, I would use [Homebrew](https://brew.sh/) with a `Brewfile` to track which CLI tools were required by my repos.
Since I'm yet to find a way to tell a `Brewfile` which version to install following [semantic versioning](https://semver.org/), I'd end up adding checks in my scripts to ensure the tools I needed where available and in the expected version.
This added a bit of overhead, and disrupted the workflow of other developers that might have updated certain tools without meaning to.

Using CocoaPods like this, I can better control the versions of some of my CLI tools, update them when I see fit, and always be sure the expected version is used.

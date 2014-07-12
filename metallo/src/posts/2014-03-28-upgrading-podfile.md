---
layout: post
title: A caveat when upgrading a Podfile
categories:
- Learn
- Bugfixing
tags:
- Xcode
- iOS
- Objective-C
- CocoaPods
published: true
seo_description: A caveat when upgrading a Podfile from an older version
keyword: Upgrading Podfile
---

I recently went through the process of upgrading a `Podfile` from a legacy codebase and bumped into an issue with a very simple solution, for those who understand how [CocoaPods](http://cocoapods.org) works under the hood.

I made an example project to show the behaviour, check it out [here](https://github.com/mokagio/mokacoding-samples/tree/podfile-upgrade).

The `Podfile` looked like this:

```ruby
link_with ['MyProject', 'MyProjectTests']

pod 'AFNetworking'
pod 'Kiwi'
```

(_it was actually longer an messier, with random newlines a lot of pods commented out, but no need to inflict you with that_)

Apart from the obsolete `Podfile` style, there's one big issue; [Kiwi](https://github.com/allending/Kiwi) should be linked only in the test target, as it is a testing framework.

Updating the `Podfile` into a more semantic and not leaky one was simple:

```ruby
target :MyProject do
  pod 'AFNetworking'
end

target :MyProjectTests, :exclusive => true do
  pod 'Kiwi'
end
```

So far so good, but at that point after running `pod install` the project didn't build anymore! The error was:

```
ld: library not found for -lPods
clang: error: linker command failed with exit code 1 (use -v to see invocation)
```

This happens to be a pretty common error, specially for newbies, and in the [CocoaPods Troubleshooting page](http://guides.cocoapods.org/using/troubleshooting.html#using-the-cocoapods-project) there's a solution for it...

...that in our case doesn't work!

After a non irrelevant amount of time spent deleting Derived Data and googling I went back to the error and asked myself: _what does `library not found for -lPods` mean?_ It means that something that should be there is not there anymore! _And what's missing?__ `library not found`. _And where are the libraries?_ In the "Link Binary With Libraries" section of the target build phase. Daaah.

So I took a look at the "Link Binary With Libraries", this is what I found:

<img src="http://mokacoding.s3.amazonaws.com/2014-03-28-linked-libraries2.png" alt="Link Binary With Libraries for the updated project"/>

If we'd rolled back to the previous version we'd seen this:

<img src="http://mokacoding.s3.amazonaws.com/2014-03-28-linked-libraries.png" alt="Link Binary With Libraries for the obsolete project"/>

Mmm... what is that new `libPods-MyProject` static library?

And then I looked at the Pods project:

<img src="http://mokacoding.s3.amazonaws.com/2014-03-28-pods-targets.png" style="width: 300px" alt="Linked Frameworks and Libraries for the updated project"/>

Can you spot it? There is no Pods target! 

And here the solution to the problem: the linker cannot find `libPods` because there is no `libPods` at all, not anymore. It is just a memory of the previous configuration that CocoaPods didn't remove.

I removed `libPods.a` from the "Linked Frameworks and Libraries" and everything was running smoothly again.

An extra thing: the same operation needs to be done for the tests target, beacuse of the `link_with ['MyProject', 'MyProjectTests']`.

Another extra thing: this _memory_ of `libPods`" error happens when you **change the name of the target** as well.

<img src="http://mokacoding.s3.amazonaws.com/2014-03-28-linked-libraries3.png" alt="Link Binary With Libraries after changing the target name"/>

---

As we develop advanced badass systems we rely on many tools and frameworks, to delegate work to someone that knows how to do it better. Knowing how those we rely most heavily upon work on a level that is deeper than what's written in the README is invaluable to save time debugging and to get the most out of them.

I challenge you to spend some time reading the source code of one of the tools you use the most. Have fun!
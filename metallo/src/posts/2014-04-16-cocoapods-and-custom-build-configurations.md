---
date: 2014-04-16
title: CocoaPods and custom Build Configurations
slug: cocoapods-and-custom-build-configurations
description: Some tips on how to use CocoaPods and customs build configurations without headaches.
tags:
- iOS
- Objective-C
- CocoaPods
- Bugfixing
---

If you run through the posts in this blog you'll find out that I'm a big fan and advocate of [CocoaPods]. It's such an awesome tool and makes my life as a developer so much easier. Most of the times.

[CocoaPods]: http://cocoapods.org

Recently I bumped into a quite annoying and mysterious [issue] while trying to use [Tweaks] by Facebook. I was finally able to sort everything out thanks to the help of [@grp], the library creator, and [@alloy], CocoaPods dad.

[issue]: https://github.com/CocoaPods/CocoaPods/issues/1934
[Tweaks]: https://github.com/facebook/Tweaks
[@grp]: https://github.com/grp
[@alloy]: https://github.com/alloy

Thanks to that issue I now have a better understanding of what CocoaPods does, and some tips to share on how to handle build configurations like a pro.

## The custom build configuration issue

The problem: when trying to use Tweaks with a build configuration in a project the linking phase was failing. Apparently some symbols used by the pod didn't exist.

```
Undefined symbols for architecture i386:
  "__FBTweakIdentifier", referenced from: ...
ld: symbol(s) not found for architecture i386
clang: error: linker command failed with exit code 1 (use -v to see invocation)
```

Tweaks is built in a way that allows developers to turn it off for production builds, collapsing the _tweakable_ values into their defaults. The way they made this possible is through [preprocessor macros]; if `FB_TWEAK_ENABLED` is `0` than the macro functions used for the _tweakable_ values are redefined into their default values. One of the places were this happens is [FBTweakInlineInternal.h].

[preprocessor macros]: http://gcc.gnu.org/onlinedocs/cpp/Macros.html
[FBTweakInlineInternal.h]: https://github.com/facebook/Tweaks/blob/master/FBTweak/FBTweakInlineInternal.h

`FB_TWEAK_ENABLED` itself is defined in [FBTweakEnabled.h] and its behaviour maps the `DEBUG` macro, if not set otherwise.

[FBTweakEnabled.h]: https://github.com/facebook/Tweaks/blob/master/FBTweak/FBTweakEnabled.h

With this understanding of how Tweaks works the error message now suggests us that there's some problem with `FB_TWEAK_ENABLED` and `DEBUG`. The linker must be getting values different by the ones I set. But how?

## How CocoaPods does its magic

@alloy opened my eyes on what was going on with this [comment] in the issue I opened.

> [...] the FBTweak headers are read and interpreted by both the projects when you build. Now when the Pods project is built without DEBUG set, the FBTweak code doesn’t actually get compiled and assembled into libPods.a, but since DEBUG=1 is set in your project the FBTweak headers think the code will be in the product and it references symbols that are not actually in any of the built object files.

[comment]: https://github.com/CocoaPods/CocoaPods/issues/1934#issuecomment-40132425

Stripped down to the very bone what CocoaPods does is adding libraries to our project for us. The sources are located in the Pods project in the workspace. CocoaPods builds for us a static library `libPods.a` with all the compiled sources and adds it to our project the same way we do with the system frameworks, in the "Link Binary With Libraries" build phase.

For this process to run smoothly is obvious that both the Pods and our project have to be configured in the same way. If that's not true we could be calling methods of a library in our project expecting the code to run in a certain way, but the actual code would be different.

Usually the libraries we use don't rely on CPP flags to switch pieces of code on and off at compile time, this is why despite using a lot of pods and custom build configurations I had never run into this kind of issue before.

## How to use CocoaPods and build configurations like a pro

The rule of thumb is that **the Pods and our target have to have the same preprocessor macro settings**.

Whenever you create a custom build configuration Xcode asks if you want to duplicate Debug or Release. The Podfile DSL has a way to tell CocoaPods which build configuration was duplicated from which, it's the second argument of the [`xcodeproj`] setting.

```ruby
xcodeproj `MyProject`, 'QA' => :release, 'Beta' => :debug
```

If some of your pods requires you to set preprocessor macros then remember what @alloy says:

> The important thing to remember here is that you cannot conditionally compile stuff by setting CPP flags from your app target only.

We need to make the Pods aware of what we set in our target. There are two ways to do this.

### With a Version-Controlled Pods Folder

If your Pods folder is under version control just set them in the Pods target that uses them in the same way you did for your target.

<img src="http://mokacoding.s3.amazonaws.com/2014-04-16-linked-libraries.jpg" />

Git (_your using git right?!_) will remember the settings forever.

### Without a Pods Folder

If the Pods are not versioned every time `pod install` or `pod update` run the Pods project is regenerated. The way to automate setting the preprocessor macro is through a [`post_install`] hook.

```ruby
post_install do |installer_representation|
  installer_representation.project.targets.each do |target|
    if target.name == "Pods-TweaksBuildConfigurationsDemo-Tweaks"
      target.build_configurations.each do |config|
        if config.name == 'QA'
          config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)', 'FB_TWEAK_ENABLED=1']
        end
      end
    end
  end
end
```

This one sets `FB_TWEAK_ENABLED=1` in the 'QA' build configuration for the Tweak's target of the Pods project.

[`xcodeproj`]: http://guides.cocoapods.org/syntax/podfile.html#xcodeproj
[`post_install`]: http://guides.cocoapods.org/syntax/podfile.html#post_install

---

There are few things as rewarding as solving a problem by understanding all the pieces of the puzzle, looking back at it and suddenly seeing everything clearly. It is something that is possible only when using open source tools.

I love the ability to look under the hood of the stuff I use, and I am  very grateful to the CocoaPods team for the awesome work they're doing. I was lucky enough to meet some of them in person, and they are all lovely people as well!

_Enjoy haking around open source_

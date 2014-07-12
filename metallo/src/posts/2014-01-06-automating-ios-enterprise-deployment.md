---
date: 2014-01-06
title: Automating iOS Enterprise Deployment with shenzhen
description: A way of automating the deployment of an iOS app for enterprise distribution using the shenzhen gem.
keyword: iOS, automation, shenzhen, Xcode, Enterprise Distribution
tags:
- iOS 
- Ruby
- Automate
- Productivity
slug: automating-ios-enterprise-deployment
---

In this short post I'm gonna have a look at how to use the splendid [shenzhen](https://github.com/nomad/shenzhen/) gem by [Mattt](http://mattt.me/) to automate the process of building an `.ipa` for enterprise distribution and shipping it.

Here's the code for the build phase:

```
ipa build \
  --workspace MyAwesomeApp.xcworkspace \
  --configuration MyAwesomeAppEnterpriseConfiguration \
  --scheme MyAwesomeAppEnterpriseScheme \
  --embed MyAweseomAppEnterpriseDistribution.mobileprovision \
  --clean \
  --archive"
```

or the shorter version:

```
ipa build \
  -w MyAwesomeApp.xcworkspace \
  -c MyAwesomeAppEnterpriseConfiguration \
  -s MyAwesomeAppEnterpriseScheme \
  -m MyAweseomAppEnterpriseDistribution.mobileprovision \
  --clean \
  --archive"
```

### How does it work?

What shenzhen does is calling `xcodebuild` for us using the proper arguments and avoiding the unreadable output. _Speaking of which, take a look at what [xcpretty](https://github.com/mneorr/XCPretty) does to help us_.

As you can see from the code above there are quite a few options to specify. In particular _in my experience_ I saw that to build properly we need **both** `--scheme` and `--configuration`. If you are reading this article you're probably already managing your enterprise build with a different pair of Build Configuration and Scheme, in order to change the Bundle Id and the other configurations, so those parameters will surely make sense to you. But why **both**? 

As far as I can see after 10 minutes of hacking this is due to the fact that shenzen looks for the configuration parameter if this is not specified, [source here](https://github.com/mokagio/shenzhen/blob/master/lib/shenzhen/commands/build.rb)), and passes it to `xcodebuild`. What happens in my case is that shenzhen guesses the wrong configuration, and this is why I have to specify it in the parameters. No big deals anyway ;)

Another thing we notice in the parameters is the `--embed XXX.mobileprovision` one. This is used to sign the build with the certificate specified for the enterprise distribution. You can download the Provisioning Profile you need from the Member Center in the [Apple Developer Portal](https://developer.apple.com/membercenter). Keep it in a safe place! Everything will work fine as long as you have the private key for that.

A tip I have regarding the Provisioning Profile is to be sure that the keychain where its keys are is _unlocked_, unless you want to the OS to pop you a dialog asking for the keychain credentials at some point. The keychain can be unlocked from the Keychain Access app.

### Time to distribute!

shenzhen's `distribute` command lets us distribute our freshly built `.ipa` through 4 different channels, [HockeyApp](http://hockeyapp.net/features/), [TestFlight](http://testflightapp.com/), upload to S3, or simple FTP. 

Take a look at the [README](https://github.com/mokagio/shenzhen/#building--distribution) for the details of the single channels, or just type `ipa distribute:XXX --help` to find out about the parameter.

It's super simple!

### Where to go from here?

* Is it possible to unlock the keychain from the script, maybe just for its execution, in order to have more protections?
* Dig better into the scheme and configuration issue, and maybe submit a PR.

I hope after reading this you'll be able save time by automating your enterprise deployment process, and use it to read my other blogpost :P

Happy deploying!

---

Thanks to [@jerryhjones](https://twitter.com/jerryhjones) for finding a typo ;)

---
layout: post
title: How to have multiple iTunes Connect accounts, and submit apps
tags:
  - Espresso
  - iTunes Connect
---

**TL;DR** You can't! There is no _Apple way_ to do it, and this is yet another frustration of working in this platform. The steps described below are just a workaround to handle multiple iTunes Connect accounts in a sane-_ish_ way.

## Step 0: Understand the problem

As you might now, despite the fact that they can be access with the same Apple ID, iTunes Connect and the Developer Portal are **two different environments**, and that's why for example you need to login in one even if you're already logged in the other.

Now, the Developer Portal handles the user case of a developer being in multiple team decently. There is a drop down that allows you to switch teams, and Xcode will download and keep all the Certificates and Provisioning Profiles up to date for you.

That's not the case for iTunes Connect, there is no drop down there. So if your client needs you to take care of the submission process for them, you'll need a bit of extra work:

1. Create a new Apple ID to be part of the client's iTunes Connect
2. Export the app `.ipa`
3. Submit it to iTunes Connect using Application Loader

## Step 1: Get an invitation to join the team's iTunes Connect

As we said, there is no concept of multiple teams a user can belong to in iTunes Connect, so the only way to get access to the client's iTunes Connect is to create a new Apple ID.

The best way I found to do that is:

1. Ask the client to invite you as part of their iTunes Connect.
2. Have them use an email alias, something like your.email**+client**@gmail.com.
3. Setup the new Apple ID with the invitation link received.

The key here is the email alias trick. Note that while this trick is know to be supported by gmail, it might not work with other providers.

In my humble opinion the alias is a nice way to overload one email address with multiple clients and be somehow able to filter them.

## Step 2: Export the app

Xcode won't be able to submit the app for you, as the `+client` Apple ID you just created is related only to iTunes Connect, and the Xcode accounts are the Developer Portal ones instead.

But don't panic, there is another way 👍

One of the tools shipped with Xcode is Application Loader, which is a simple app to submit `.ipa` files to iTune Connect. You can find it in the Xcode > Open Developer Tools menu.

The way you get an `.ipa` files is by exporting an archive. You can create the archive for the app the usual way, then from the Organizer window, use the Export... button and select "Save for iOS App Store deployment". You'll then be able to save the `.ipa` file where you want.

## Step 3: Submit the app using Application Loader

Now that you have your nice `.ipa` package you can open Application Loader, login with the `+client` credentials.

To submit to iTunes Connect select the "Deliver Your App" _template_, press "Choose", the select the previously saved `.ipa`.

That's all.

### Food for thought

* How to automate this process, have a look at [fastlane](https://fastlane.tools/).

---
layout: post
title: How to update an Xcode plug-in for the latest version of Xcode
description: A simple command to run in your terminal to make sure you can use your favourite plugins on the latest version of Xcode
tags:
  - Espresso
  - Xcode
---

Every time a new version of Xcode is released the same drama starts to play: none of the plug-ins work.

Most of the time this is due to the plug-in maintainer not having had the time yet to update the `DVTPluginCompatibilityUUIDs` array to include the `DVTPluginCompatibilityUUID` of the latest Xcode.

This line of code does that for you, while you wait for a proper update to be released:

```
defaults write ~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins/XVim.xcplugin/Contents/Info  DVTPlugInCompatibilityUUIDs -array-add $(defaults read /Applications/Xcode.app/Contents/Info DVTPlugInCompatibilityUUID)
```

Note that in the command above the plug-in I'm updating is `XVim.xcplugin`, you should replace that with the name of the plug-in you want to update.

If you need any help with this please hit me up on Twitter [@mokagio](https://twitter.com/mokagio), or leave a comment below.

_Happy coding, and leave the codebase better than you found it._


---
title: iTerm2 microphone permission for Claude Code
description: How to grant microphone permission to iTerm2 on macOS to use with Claude Code voice mode
tags:
- Espresso
---

Claude Code [introduced voice mode](https://x.com/trq212/status/2028628570692890800?s=20).

I wanted to try it out but my [iTerm2](https://iterm2.com/) had no microphone permission on macOS.

Before the horrific UX downgrade that is Thaoe, I would had clicked a `+` button in the Privacy & Security > Microphone, but the option is no longer there.

![The microphone permission settings with no option to add the app](https://mokacoding.s3.amazonaws.com/202603-thaoe-no-plus-button-microphone.png)

I tried dragging and dropping iTerm2 from the doc to the settings, but it did not work.

After some more trial and error, I found the following snippet to be capable of triggering the microphone permission prompt.

First, reset the permission request status, just in case:

```
tccutil reset Microphone com.googlecode.iterm2
```

Then, run a command that requires audio input:

```
swift -e 'import AVFoundation; AVCaptureDevice.requestAccess(for: .audio) { granted in print(granted ? "Granted" :
  "Denied"); exit(0) }; RunLoop.main.run()'
```

Tada!

![The microphone permission prompt alert](https://mokacoding.s3.amazonaws.com/202603-iterm2-microphone-permission-thaoe.png)

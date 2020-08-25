---
title: How to check if macOS app is notarized
tags:
- Espresso
---

Today I was wondering wheter a `.app` I uploaded to a third-party distribution provider was notarized due to an error I saw when launching it.

Me being me, I naturally checked for a Terminal option, and I stumbled upon [this post from the developers forum](https://developer.apple.com/forums/thread/115788) which suggests to use `spctl`:

```
spctl -a -t exec -v /path/to/notarised.app
source=Notarized Developer ID

spctl -a -t exec -v /path/to/not_notarised.app
source=Developer ID
```

The command is a "subsystem maintains and evaluates rules that determine whether the system allows the installation, execution, and other operations on files on the system."

`-a` requests an assessment on the given file, `-t execute` specifies the assessment is for code execution, `-v` makes the output verbose (the more `v`s you add the more verbose it gets, but I haven't seen any difference between `-vv` and `-vvv`, and the only really useful information was already part of `-v`)

Something else I notices was that the `.app` in the `.xcarchive` stored in `/Library/Developer/Xcode/Archives` was not stapled despite having gon through notarization successfully.

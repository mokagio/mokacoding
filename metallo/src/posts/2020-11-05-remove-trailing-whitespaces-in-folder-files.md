---
title: How to remove trailing whitespaces from all files in a folder
description: "Here's a shell command to trim all the trailing whitespaces in all the files of the current folder."
tags:
- Espresso
- Terminal
- Automation
---

From the Terminal, `cd` into the root folder containing the files with trailing whitespaces, then run the following command:

```bash
find . -not \( -name .git -prune \) -type f -print0 | LANG=C LC_CTYPE=C xargs -0 sed -i '' -E "s/[[:space:]]*$//"
```

---

Today I had a play around with [BuildSettingsExctractor](https://github.com/dempseyatgithub/BuildSettingExtractor), an app that reads a `project.pbxproj` file from the [Xcode IDE]() and extracts all the build settings into dedicated files.

The app added helpful documentation comments to each setting it extracts, but the formatting was a bit off: the empty comment lines had a trailing whitespace.

Trailing whitespaces do not impact the app performance and they are not a source of bugs.
Still, they are incredibly irritating and unnecessary.

I couldn't help myself and looked for a way to remove them that didn't involve editing all of the files manually.
I found it in [this](https://stackoverflow.com/a/5130044/809944) answer, which I tweaked a bit to make it a one liner, as shown above.

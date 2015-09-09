---
layout: post
title: "How to install Xcode Command Line Tools without GUI or Xcode"
description: "Here's a little script that will allow you to install the Xcode Command Line Tools without having to install Xcode, nor having a logged GUI. This can come pretty handy in automated scripts or when provisioning virtual machines."
tags:
  - Espresso
  - Xcode
  - Automation
---

If you are in the business of setting up new development machines or virtual machines you probably know that to do almost anything you need to have the **Xcode Command Line Tools**.

Being something that only devs need Apple doesn't ship them with OS X, as far as Yosemite at least, so you need to install them yourself.

The canonical way to do it is to install Xcode itself, but that means downloading a couple of GB of app from the store, which might take time.

[Another option](http://railsapps.github.io/xcode-command-line-tools.html) is to open a Terminal and type `xcode-select --install`.

Both the options above have a flaw: they require a GUI. That is not optimal when trying to setup a VM in an automated way.

In [this AskDifferent answer](http://apple.stackexchange.com/questions/107307/how-can-i-install-the-command-line-tools-completely-from-the-command-line) a solution without GUI is proposed, and here you can find my spin on it:

```
#!/bin/bash

# See http://apple.stackexchange.com/questions/107307/how-can-i-install-the-command-line-tools-completely-from-the-command-line

echo "Checking Xcode CLI tools"
# Only run if the tools are not installed yet
# To check that try to print the SDK path
xcode-select -p &> /dev/null
if [ $? -ne 0 ]; then
  echo "Xcode CLI tools not found. Installing them..."
  touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
  PROD=$(softwareupdate -l |
    grep "\*.*Command Line" |
    head -n 1 | awk -F"*" '{print $2}' |
    sed -e 's/^ *//' |
    tr -d '\n')
  softwareupdate -i "$PROD" -v;
else
  echo "Xcode CLI tools OK"
fi
```

Easy peasy ☺️ I also made a gist with this, which you can download [here](https://gist.github.com/mokagio/b974620ee8dcf5c0671f).

_Happy coding, and leave the codebase better than you found it_

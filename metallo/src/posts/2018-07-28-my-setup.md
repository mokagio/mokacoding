---
layout: post
title: "Apps and Tools"
description: "A list of the apps and tools I use everyday and help me getting stuff done."
tags:
- Apps
---

These are the apps and tools I use everyday. They help me getting stuff done, and I recommend them all to you.

[Alfred](#alfred), [Shortcat](#shortcat), and [Hammerspoon](#hammerspoon) let me do almost anything without touching the mouse. [Pocket](#pocket), [Evernote](#evernote), and [Dropbox](#dropbox) are where I put things so that they're synced in the cloud. I offloaded remembering all my passwords to [1Password](#1password). I use [Tadam](#tadam) to pace my work, and [RescueTime](#rescuetime) to monitor where I'm spending my time on. On my phone, [Productive](#productive) helps me work on my habits and routines, and [Spark](#spark) moves towards inbox zero. When coding and writing I spend most of my time in [iTerm](#iterm) and [Vim](#vim).

## [Alfred](https://www.alfredapp.com/)

Alfred allows you to bind hotkeys and keywords to almost anything. It has a minimalistic interface, a text field you can summon using an hotkey, I use `Option` `Space`. From there you start typing what you'd like to do and Alfred smart text expansion will match the most likely target.

Some of the workflows I use most often are:

- Use Alfred to launch apps without having to find them in the applications folder. Type `x` and my first result is Xcode.
- `s <word>` to see the definition of a word, it's fuzzy so I don't have to spell it right.
- `spf` to reveal an interface that shows the information about the track currently playing in Spotify without having to navigate to it. It also allows to pause or play the track.

Alfred has a Clipboard history feature which can store anything you've copied and let you search through it. You can copy multiple things from a page, move to the other and then use the clipboard history to paste them. Much more effective than switching between apps all the time.

## [Shortcat](https://shortcatapp.com/)

Like Alfred, Shortcat saves me from having to use the mouse. Using a configurable hotkey, like `Shift` `Cmd` `Space`, you can bring up a text input where to write the name of the element in the screen you want to click.

Shortcat has fuzzy matching and uses the accessibility identifiers of the elements on screen, making it accurate and efficient at finding what you're typing.

## [Hammerspoon](https://www.hammerspoon.org/)

Hammerspoon is an open source "bridge between the operating system and a Lua scripting engine". I use it as window manager, with hotkey sequences to move my window to half of the screen to the left, half to the right, etc.

You don't need to know Lua to configure Hammerspoon. I don't know it either and still managed to configure [my setup](https://github.com/mokagio/dotfiles/tree/HEAD/hammerspoon_init.lua) the way I wanted it. Just play around with the code in the examples of the [documentation](http://www.hammerspoon.org/go/#winmoveintro).

## [Tadam](http://tadamapp.com/)

Tadam is a minimalistic timer inspired by the [Pomodoro technique](https://francescocirillo.com/pages/pomodoro-technique). It stays out of your way while counting down, then gets in your face when the time is up.

I love it because it solves a problem I often have. I plan to time box things to take regular breaks, but always end up getting stuck in them, or starting something else once done. Before I know it an hours has passed and I haven't taken any break.

Tadam shows an alert that takes up most of the center of the screen, on top of every window. It is a great way to force yourself to take breaks and give your brain a bit of fresh air, making you more productive later.

## [RescueTime](https://www.rescuetime.com/)

RescueTime tracks the time you spend on each app and generates reports on it. Tracking how time is spent is the first step to become more productive, as it reveals what you actually do compared to what you _think_ you do.

Tracking how time is spent is the first step towards using time wisely. It reveals what you actually do compared to what you _think_ you do.

It can give you some tough love showing you how many hours you've spent on social media while you thought you were working hard.

## [Evernote](https://evernote.com/)

There are two parts of a trusted system for collecting notes. It has to be easy to add notes, and it has to be easy to find them out later. [Evernote](https://evernote.com/) has a bloated UI and doesn't yet support [Markdown](http://commonmark.org/help/) editing, but makes it all up with how powerful it is at searching through notes and OCRed images.

I use it every day, scan my receipts with it too, and haven't needed to upgrade to the Pro version yet

## [Dropbox](https://www.dropbox.com/)

Most of my file system lives either on a Git server or on Dropbox. I use Dropbox to back up all the pictures taken with our phones as well. It's good peace of mind, and comes in handy when switching computers, or when on the go without one.

## [1Password](https://1password.com/)

When I was younger I had what I thought was a smart "algorithm" to compute the password for a website using some properties of that website. I felt smart for not having problems remembering passwords, and always using a different one. My system worked fine, but it was silly, not to mention vulnerable and insecure.

Using a password manager is a better option. You only need to remember one -long and memorable, but hard to crack- password, and that's it. It will generate and store all your passwords from you, doing a much better job at coming up with hard to break passwords than you or I can.

I use 1Password to store all my passwords, together with MFA on any site that supports it. The experience of using it is becoming almost frictionless, even on mobile. I love it. I really encourage you to start using a password manager.

## [iTerm](https://www.iterm2.com/)

iTerm is a more powerful terminal application than the stock macOS one. It offers split panes, infinite scrolling, searching with mouseless copy, and [much more](https://www.iterm2.com/features.html).

## [Vim](https://www.vim.org/)

Whenever I can I write using Vim. In fact I'm writing this using it, in [iTerm](#iterm).

Modal editing is an effective way to write and edit any kind of text. Not having to use the mouse to move around the page is great. Plus there are many plug-ins for any kind of job, which allows you to configure Vim to serve your needs, like a tailor made shirt.

## [Productive](http://productiveapp.io/)

I use this little app on my iPhone to track habits that I'm building and daily routines. It lets you set times of the day when you'd like to do certain things, as well as recurring habits. There are so many things I have to do on a regular basis but always forget, Productive helps me with them.

## [Pocket](https://getpocket.com)

Any article I find interesting or I'd like to read later I save to Pocket, possibly with a tag. I realise there might be a flaw in this process because the rate at which I save things in is far bigger that the one at which I read things out. Still, it's a great tool to store articles and find them later.

They recently added an highlight feature on mobile. It's handy to be able to highlight parts of posts and only look at those later.

## [Spark](https://sparkmailapp.com/)

Spark is a nice email client for both iOS and macOS, although I use it only on my phone. I like the snooze feature, and the integration with Pocket and other services to save links from emails.

## [TripMode](https://www.tripmode.ch/)

I do a fair bit of train commuting and have unreliable wired connection at home so I tether often. TripMode allows you to select which apps should access the network when connected via your phone. It avoids wasting bandwidth, and money. You might be surprised by this, but a country like Australia doesn't offer an all-you-can-eat data plan, not for a reasonable amount of money at least.

---

Apps and tools will not suddenly make you more productive. Productivity is first of all a mindset, it's a set of behaviours and habits that you need to keep working on all the time. What apps and tools can do though is **help you leverage those productive behaviour becoming more efficient and organized at what you do**.

Have you got any favourite app you'd like to suggest? Leave a comment below or get in touch via Twitter at [@mokagio](https://twitter.com/mokagio).

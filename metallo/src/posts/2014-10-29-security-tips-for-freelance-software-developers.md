---
title: Security Tips for Freelance Software Developers
description: Tips for freelance software developers (and non) to improve the security of laptops, smartphones and website accounts, to keep your and your clients data safe.
---

The security of our digital identities and properties is a topic of ever growing importance, with more and more sensible data and informations we depend on being stored on our devices or in the cloud.

As freelancer software engineer should be even more aware of how secure your machine and devices are, as not only your data is stored there, but your clients as well. Taking your client security seriously is a sign of professionally, and could turn out to be a life saver if something happens to your laptop.

Here's a list of simple actions that you can take right now to improve your "security rating".

## Lock your screen

This is the abc. You probably learned it when you were at school and somebody [fraped](http://www.urbandictionary.com/define.php?term=Fraped) you. When you're not in front of your machine, lock it.

It takes only a couple of days to build up the habit of locking the screen every time you walk away from it, but a safe "lazy proof" way is to set the screensaver timeout for one minute.

**Pro tip:** The productivity tool Alfred for Mac makes locking your screen as easy as the hitting `Alt + Space`, `l`, `Enter`.

**Pro tip:** Having short timeouts can become annoying when you're watching things on your computer. [Caffeine](https://itunes.apple.com/au/app/caffeine/id411246225?mt=12) is a tiny free Mac app that prevents your screen from going to sleep automatically. And guess what? There's an [Alfred workflow](https://github.com/shawnrice/alfred2-workflow-toggle-caffeine) for it too.

## Lock your devices

Your phone might not have the ssh key to download all your client codebase and sell it to it's competitors, but has something as powerful: your email! With access to your email even a teenager can do some serious damage.

So add a passcode to your smartphone!

## Use strong passwords and consider a password manager

Your account is as secure as your password. But what makes a password secure? There is a lot to say about it, here some fun starting points: [xkcd on strong passwords](http://xkcd.com/936/),  [xkcd on password reuse](http://xkcd.com/792/), and an [infographic on password security](http://lifehacker.com/5876541/use-this-infographic-to-pick-a-good-strong-password).

You could also consider using a password manager. Password managers are a matter of tastes. I'm personally not a big fan of them, they are a single point of failure, and add friction. But it's undeniable that using a password manager will allow you to use secure password, being them very long or rich of symbols, taking away the effort of remembering them.

## Use multi factor authentication

An extra layer of security can be added to your email, GitHub, etc. by enabling multi factor authentication.

> Multi-factor authentication (MFA) is a method of computer access control which a user can pass by successfully presenting authentication factors from at least two of the three categories: Knowledge factors ("things only the user knows”), such as passwords;  Possession factors ("things only the user has"), such as ATM cards; Inherence factors ("things only the user is"), such as biometrics.

_From [Wikipedia](http://en.wikipedia.org/wiki/Multi-factor_authentication)._

Once you’ll have setup a couple of accounts with MFA you’ll find yourself addicted to it. It’s gonna be a disappointment when you’ll have to sign up for a service that doesn’t offer it.

<img src="https://mokacoding.s3.amazonaws.com/2014-10-29-mfa-all-the-things.jpg" alt="Freelance software developers should MFA all the things to keep their accounts secure"/>

### List of all the services I use supporting MFA

* [Google](https://www.google.com.au/landing/2step/)
* [GitHub](https://help.github.com/articles/about-two-factor-authentication/)
* [Amazon AWS](http://aws.amazon.com/iam/details/mfa/)
* [Facebook](https://www.facebook.com/note.php?note_id=10150172618258920)
* [Twitter](https://blog.twitter.com/2013/getting-started-with-login-verification)
* [Evernote](http://blog.evernote.com/blog/2013/05/30/evernotes-three-new-security-features/)
* [Dropbox](https://www.dropbox.com/en/help/363)

**Pro tip:** Instead of relying on the authentication token being sent you through SMS, use [Authy](https://www.authy.com/). Authy is a great app to access your MFA accounts from the smartphone and offers extra features such as backups and multiple devices support.

## Encrypt your disk

Another simple measure you can take to make your machine more secure is to encrypt your disk. This will prove incredibly valuable in case you forget your laptop somewhere, or if it gets stolen.

Some disk encryption softwares provide [deniable encryption](http://en.wikipedia.org/wiki/Deniable_encryption). They create an _hidden volume_. You can then have a "normal" password to unlock the disk, while keeping the data that's really important and sensible in an hidden volume, that can be unlocked only if a "secret" password is used instead.

If you're on Mac you can use [Filevault](http://support.apple.com/kb/ht4790). Note that Filevault doesn't provide deniable encryption.

## Wrapping it up

We saw a few simple moves that everybody, not just freelance software developers, can and should take, to improve their security, and make their clients and themselves more comfortable.

If you have other tips to improve security [tweet me](https://twitter.com/mokagio) about it.

_Happy coding, on your secure machine._

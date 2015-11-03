---
layout: post
title: "How to configure CircleCI for iOS testing"
description: "A practical guide on how to configure CircleCI for to run iOS, and OS X, tests."
tags:
  - CI
  - CircleCI
  - Xcode
---

Whether you are using Swift or Objective-C, developing a little open source framework or the next App Store hit, having a solid CI setup is very important to guarantee a fast feedback loop, and a reliable development pipeline.

In this article we are going to see how to use [CircleCI](https://circleci.com/) to test iOS, and OS X applications. Oh! And watchOS and tvOS as well.

**Note:** Before configuring CircleCI you'll need to make sure that the Xcode Scheme used to run the test is shared, so that it will be downloaded as part of the repo checkout and Circle will find it when attempting to run the tests.

## circle.yml

CircleCI offers multiple options to configure the CI job. The best one in my opinion is to use a `circle.yml` file in the root of your project.

In case you are not familiar with it, a `.yml` file is a file written in [YAML](http://yaml.org/), a very simple data serialization language, and [a JSON subset](http://yaml.org/spec/1.2/spec.html#id2759572).

Here's the one of simplest `circle.yml` you could write:

```yml
machine:
  xcode:
    version: "7.0"

test:
  override:
    - ./bin/tests
```

That's it. This configuration file will make sure that your build will run on a machine with Xcode 7.0, the run the executable script located at `bin/tests`.

Using a script file where the test commands are rather than letting CircleCI guess how to run them itself has a number of advantages. First and foremost, it makes it so that you can run the same command the CI will use on your machine, which is important because you want to personally test your CI setup. On top of that it keeps the configuration file decoupled by the implementation details how the tests should run, and makes it more readable.

Checkout [this post](http://www.mokacoding.com/blog/running-tests-from-the-terminal/) for a closer look on how to write such a script.

## Other configurations

The [`circle.yml`](https://github.com/mokacoding/Bench/blob/master/circle.yml) of [Bench](https://github.com/mokacoding/Bench), one of the example projects used to in posts like "[Xcode 7 UI testing, a first look](http://www.mokacoding.com/blog/xcode-7-ui-testing/)" and "[Job stories acceptance tests using KIF and Specta](http://www.mokacoding.com/blog/job-stories-acceptance-tests-with-kif-and-specta/)", adds is similar to the one above, but with an extra section:

```yml
machine:
  xcode:
    version: "7.0"

dependencies:
  override:
    - bundle install

test:
  override:
    - ./bin/unit-tests
```

Bench uses [xcpretty](https://github.com/supermarin/xcpretty) to format the tests' output. The tool is installed as a Ruby gem, using [Bundler](http://bundler.io/).

What the `circle.yml` does is overriding the dependencies step, to run `bundle install`.

In [this `circle.yml`](https://github.com/mokagio/Quick/blob/mokagio/test-xctool/circle.yml) from the [Quick](https://github.com/Quick/Quic) project we do two extra things, update the git submodules, and make sure the `xctool` version `brew` is up to date.

```yml
machine:
  xcode:
    version: "7.0"

checkout:
  post:
    - git submodule update --init --recursive

dependencies:
  pre:
    - brew update || brew update
    - brew outdated xctool || brew upgrade xctool

test:
  override:
    - rake test:ios
    - rake test:osx
    - rake test:xctool_ios
```

## A note on dependencies

You might have noticed that I have made no mention yet to `pod install` or `carthage bootstrap`. That is because I've found that is way better to check in your projects dependencies under version control rather than having the CI downloading every time. Not only you will get a faster build, but also remove the network as a possible point of failure. For example GitHub being offline would not prevent the dependencies to being downloaded, resulting in the build failing.

---

This has been a quick practical introduction on how to configure CircleCI for iOS testing. If you need to look deeper into the topic head over to the [Circle documentation page](https://circleci.com/docs/ios), or look at how the open source libraries you use do it. Also, feel free to leave a comment below or hit me up on Twitter [@mokagio](http://twitter.com/mokagio) if you need help.

_Happy coding, and leave the codebase better than you found it._

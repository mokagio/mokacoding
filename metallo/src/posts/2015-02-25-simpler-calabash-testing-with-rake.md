---
layout: post
title: How to simplify Calabash acceptance testing with Rake
description: Rake, the Ruby build utility, can lift off all the typing involved in running the Cucumber/Calabash acceptance tests, saving us a lot of typing time.
tags:
- Acceptance Testing
- Calabash
- Productivity
---

Not too long ago I wrote about how to [setup Calabash in our project](http://www.mokacoding.com/blog/calabash-ios-with-cocoapods-and-build-configurations/) in an unobtrusive and easy to maintain way.

In this post we'll see how to streamline our testing flow by saving a lot of typing thanks to Rake tasks.

If you're not familiar with it, [Rake](https://github.com/ruby/rake) is a Ruby version of Make, and it's a way can use to run tasks.

As you know, to run the tests with Calabash you have to type `cucumber`. This works fine in the examples from the repo, but it's likely you'll need to set [more options](http://calabashapi.xamarin.com/ios/file.ENVIRONMENT_VARIABLES.html), like for example resetting the Simulator between each scenario, or a special path for the screenshots take when a test fails.

Since options are passed as environment variables, with a bit of shell-fu you could setup a local file were you export variables, but this doesn't work well with team work, not everybody may have that shell, and it's usually a bad practice to force a team member to change their env to start working.

The advantages of using Rake instead are:

* Quick on boarding of new developers on the project, they'll simply have to run `rake <task-name>`.
* Never forget the syntax and options for a command, they are all written in the Rakefile.

These tasks will build and run the tests on the Simulator, specifying that we want an iPhone 6 Simulator running iOS 8.1, and that it should be reset before each test case.

```ruby
@build_dir = ...
@workspace = ...
@scheme = ...
@configuration = ...
@app_name = ...

desc 'Build a "calabashed" version of the app'
task :build do
  build_fat_binary = <<COMMAND
xcrun xcodebuild \
-SYMROOT=#{@build_dir} \
-derivedDataPath "#{@build_dir}" \
  ARCHS="i386 x86_64" \
  VALID_ARCHS="i386 x86_64" \
  ONLY_ACTIVE_ARCH=NO \
  -workspace #{@workspace} \
  -scheme #{@scheme} \
  -sdk iphonesimulator \
  clean build
COMMAND

  sh build_fat_binary
end

desc 'Run all the calabash/cucumber acceptance tests on the simulator.'
task :simulator_tests => [:build] do
  app_path = "#{@build_dir}/Build/Products/#{@configuration}-iphonesimulator/#{@app_name}.app"

  run_tests = <<COMMAND
bundle exec cucumber \
RESET_BETWEEN_SCENARIOS=1 \
DEVICE_TARGET='iPhone 6 (8.1 Simulator)' \
APP_BUNDLE_PATH="#{app_path}" \
COMMAND

  sh run_tests
end
```

Now instead of typing `bundle exec cucumber DEVICE_TARGET=...` and all the rest, we can simply do `rake simulator_tests`. I consider this a huge win.

When it comes to run tests on device you could use this task.

```ruby
@ip = ...
@uuid = ...
@bundle_id = ...

desc 'Run all the calabash/cucumber acceptance tests on the connected device.'
task :device_tests => do
  run_tests = <<COMMAND
bundle exec cucumber \
  BUNDLE_ID="#{bundle_id} \
  DEVICE_ENDPOINT=http://#{@ip}:37265 \
  DEVICE_TARGET='#{@uuid}'
COMMAND

  sh run_tests
end
```

The above tasks has two flaws, the device UUID and ip are hard-coded, and it assumes the app is already on the device.

We can fix the first issue by moving the configurations in a `.yml` file.

```yaml
uuid: "device UUID"
ip: "device IP when on the same network as the machine running the tests"
```

```ruby
desc 'Run all the calabash/cucumber acceptance tests on the connected device.'
task :device_tests => do
  settings_file = Dir.pwd + '/.calabash_device_config.yml'
  raise "Missing calabash)device_config.yml in root folder." unless File.exists? settings_file

  configs = YAML.load_file settings_file

  run_tests = <<COMMAND
bundle exec cucumber \
  BUNDLE_ID="#{bundle_id} \
  DEVICE_ENDPOINT=http://#{configs['ip']}:37265 \
  DEVICE_TARGET='#{configs['uuid']}'
COMMAND

  sh run_tests
end
```

To make this setup team friendly we can add the `.yml` file to the `.gitignore` of the project, and track a copy of it with dummy values and `.yml.sample` instead.

We've removed the need to hardcode UUID and IP, but we're still depending on the fact that the app is already installed on the device.

As of Xcode 6.1.1 Apple has not provided a tool to deploy an app on device from the command line  Lucky enough the open source community has a solution for that. [ios-deploy](https://github.com/phonegap/ios-deploy), previously known as [fruitstrap](https://github.com/ghughes/fruitstrap), and maintained by the PhoneGap community, lets you deploy an ipa on a connected device as easily as `ios-deploy -b MyApp.ipa`.

_ios-deploy is distribute via npm, but if you'd like two add it to your project's Gemfile you can do it thanks to [this gem](https://github.com/mokagio/ios-deploy-gem)._

The missing piece of the puzzle is how to build the app in a format that can be deployed to the device. To keep things simple we're gonna use the [shenzhen](https://github.com/nomad/shenzhen) gem. The command needed to build is:

```
ipa build --workpace ... --configuration ... --scheme .. --archive --sdk iphoneos --ipa "MyApp.ipa"
```

Putting it all together:

```ruby
desc 'Run all the calabash/cucumber acceptance tests on the connected device.'
task :device_tests => do
  settings_file = Dir.pwd + '/.calabash_device_config.yml'
  raise "Missing calabash)device_config.yml in root folder." unless File.exists? settings_file

  configs = YAML.load_file settings_file

  ipa_name = ...
  archive = <<COMMAND
bundle exec ipa build \
  --workpace ... \
  --configuration ... \
  --scheme .. \
  --archive \
  --sdk iphoneos \
  --ipa "#{ipa_name}"
COMMAND

  send_to_device = <<COMMAND
bundle exec ios-deploy \
  --bundle #{ipa_name} \
  --id #{configs['uuid']}
COMMAND

  run_tests = <<COMMAND
bundle exec cucumber \
  BUNDLE_ID="#{bundle_id} \
  DEVICE_ENDPOINT=http://#{configs['ip']}:37265 \
  DEVICE_TARGET='#{configs['uuid']}'
COMMAND

  sh archive
  sh send_to_device
  sh run_tests
end
```

The task above is doing a lot, imagine if you had to do it every time you want to run tests on the device!

Setting up these tasks will save you the effort of remembering all the cucumber option, save you typing, and also make the running the acceptance test easy for the team members that don't know about cucumber and calabash.

Happy coding, and keep the codebase better than you found it


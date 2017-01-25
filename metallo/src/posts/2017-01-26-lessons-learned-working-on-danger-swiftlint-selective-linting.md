---
layout: post
title: "Lessons learned working on danger-switling selective linting"
description: "A little post to share some things I learnt while working on a PR for danger-swiftlint to allow selective linting."
tags:
- Espresso
- Ruby
- Open Source
---

A few weeks ago I opened a PR on [danger-swiftlint](https://github.com/ashfurrow/danger-swiftlint), a plugin for [Danger](https://github.com/danger/danger) that runs as part of your CI and will post a comments with all the style violations reported by [SwiftLint](https://github.com/realm/SwiftLint) on the files touched by the PR. This work gave me the chance to learn more about Ruby development and testing, and I'd like to share my findings here.

The changes my PR made aimed to address the problem described in [this issue](https://github.com/ashfurrow/danger-swiftlint/issues/16). The previous version of the plugin used to run the linting on all the files in the project due to a [limitation](https://github.com/realm/SwiftLint/issues/551) in how SwiftLint itself handles command line options while also given a config file.

In the issue there was also a proposed solution. We can workaround the SwiftLint limitation by providing a configuration file that would not conflict with the options used to run the tool.

What my PR did was exactly that. First look for a configuration file, and if found generate a copy on the fly that does not include the node specifying which paths to inspect, and then call SwiftLint using the newly generated configuration file.

This is not rocket science, and the Ruby code to implement this is fairly trivial. What I find worth sharing is the way the code is tested.

The way the plugin is tested is through heavy use of [RSpec](http://rspec.info/) stubs and mocks. Each possible way in which the plugin can run is an example in which the `swiftlint` binary is mocked to be allowed to be invoked in a certain fashion, and return a certain value. This allows us to test two things, that SwiftLint is called in the right way, and that the data manipulation performed by the plugin behaves as expected.

When contributing to someone else's codebase it is important to be aware of the style used, and try to stay in line with it. This is not the style of testing that I would use, but it was interesting and fun to force myself to work in that fashion.

What I found challenging during my work on the PR was how to mock the behaviour of `Tempfile` in order to test that my code used it properly.

## How to mock Ruby Tempfile open block in RSpec

As said above the new code added by my PR generates a new configuration file on the fly and uses it instead of the one present in the repository. To do this we use [`Tempfile`](http://ruby-doc.org/stdlib-1.9.3/libdoc/tempfile/rdoc/Tempfile.html).

When working with files in Ruby it is always important to clean after yourself, that is, to ensure that the files are properly close after you are done working with them. My favourite way to do so is to use API that accept a block, and that take care of closing the file for you. I find this more robust to changes that using `begin ensure end`.

Now here's the problem I had to solve while writing the tests. Unit testing is all about controlling the inputs given to the system under test, and verifying the outputs it generates are as expected. The behaviours I needed to test were:

- The configuration file generated on the fly does not contain the configuration node that results in clashes with the CLI option
- `swiftlint` is invoked by passing it the newly generated configuration file

Central to testing both these behaviour is knowing the path of the temporary file, so that we can ready it and compare it with the one used in the invocation.

To do so we need to stub the method used to generate such temporary file, [`Tempfile#open`](http://ruby-doc.org/stdlib-1.9.3/libdoc/tempfile/rdoc/Tempfile.html#method-i-open).

RSpec provides a way to stub a method call response by [yelding to the caller's block](https://www.relishapp.com/rspec/rspec-mocks/v/3-2/docs/configuring-responses/block-implementation#yield-to-the-caller's-block):

That's all I needed 😄.

```ruby
fake_temp_file = Tempfile.new('fake.yml')

# Using begin-ensure-end here to avoid confusingly calling Tempfile.open and
# stubbing it at the same time.
begin
  allow(Tempfile).to receive(:open) { |&block| block.call(fake_temp_file) }
  # Rest of the test...
ensure
  fake_temp_file.close
  fake_temp_file.unlink
end
```

## How to remove keys from a Ruby hash

Part of what the PR needed to do was to generate a new configuration YAML file that wouldn't include the node that the CLI option cannot override.

To do so the original configuration file is read and put into an hash. The hash is then mutated removing the key corresponding to the setting that needs to be overridden via CLI. Finally the hash is converted back into YAML and wrote into the temporary file.

I naively thought that setting its value to nil would have been enough to remove a key from an hash. I should have though about it for longer that one second.

Setting a key's value to nil… sets it's value to nil 😅 The key is still there.

This is usually ok in code because we usually do things like `unless hash[:key].nil? do ...`. In the case of serialization to YAML that's no good though, as what we'd get is a YAML with an empty node corresponding to the key with nil value.

```ruby
require 'yaml'

hash = { foo: nil }

hash.to_yaml
# => "---\n:foo: \n"
```

The correct way to remove a key from an hash is to use `tap`.

```ruby
{ foo: nil, bar: 'baz' }.tap { |hash| hash.delete(:foo) }
# => { :bar =>"baz" }
```

---

I love open source and being able to support the projects I use by contributing to them. Submitting pull requests is always a great occasion to learn new things and to grow as a developer. I encourage you to do the same!

If you know of a better way of achieving the same results as I did, or if you have any other  please leave a comment below or get in touch on Twitter [@mokagio](https://twitter.com/mokagio).

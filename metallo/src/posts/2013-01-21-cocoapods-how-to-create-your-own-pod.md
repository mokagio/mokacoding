---
date: 2013-01-21
title: CocoaPods - How to create your own Pod
tags:
- CocoaPods
- git
- iOS
- Objective-C
description: A step by step guide to create a basic CocoaPod.
---
Like I said in the <a href="http://amokafullofstuff.wordpress.com/2013/01/05/cocoapods/">first part</a> of my exploration of CocoaPods, using this iOS dependencies management is freaking easy, and reading what's on the homepage is more than enough to get started. Anyway let's see how we can create our how Pods.

To learn how to do it I started the development of a little "framework" I called <a href="https://github.com/mokagio/MGCraftman">MGCraftman</a>, where I'll put some utils methods I sometimes write to speed up UI development when I'm not using Interface Builder. But let's stop the chitchat and let's code!

<h3>Step 1 - Code the Library!</h3>
The first step is to have something to make a pod of, I guess every developer has his own little set of smart methods that make his life easier. Don't be greedy, share them with the community!
<h3>Step 2 - Tag your pod properly</h3>
Since we're gonna work with a dependency manager we need to take care of the version number of our pod.

	git tag -a 1.0.0 -m "Tag release 1.0.0"
	
Take a couple of minutes to read through the <a href="http://semver.org/">Semantic Versioning</a> to learn how to use tagging for version numbers properly and in a way that allows for <a href="https://github.com/CocoaPods/Specs/wiki/Cross-dependencies-resolution-example">resolution of cross-dependencies</a>.
<h3>Step 3 - The podspec</h3>
Once our project is tagged properly we can create the <code>.podspec</code> file. The extension name explains that it will contain the "specs" of our "pod".

	pod spec create Donut

This will generate the <code>Donut.podspec</code> file.

You can also generate the <code>podspec</code> from a GitHub repo using the GitHub url instead of the name.
<h3>Step 4 - Leave your mark on the podspec</h3>
If you open the freshly generated <code>Donut.podspec</code> you'll find a lot of comments explaining the information you need to provide. There are a lot of options, but you don't need to set them all. You'll also notice that its nothing more that a Ruby file.

Here's how the podspec of my toy framework, looks like.

	{% highlight objective-c %}
	Pod::Spec.new do |s|
	  s.name         = "MGCraftman"
	  s.version      = "0.1.0"
	  s.summary      = "A framework to speedup development when you can't (or don't want to) use Interface Builder."
	  s.homepage     = "https://github.com/mokagio/MGCraftman"
	
	  s.license      = { :type =&gt; 'MIT', :file =&gt; 'LICENSE' }
	
	  s.author       = { "Giovanni Lodi" =&gt; "mokagio42@gmail.com" }
	
	  s.source       = { :git =&gt; "https://github.com/mokagio/MGCraftman.git", :tag =&gt; "0.1.0" }
	  s.source_files = 'MGCraftman/*.{h,m}'
	
	  s.platform     = :ios
	end
	{% endhighlight %}

<h3>Step 5 - Is my podspec ok?</h3>
Once your <code>podspec</code> its ready validate it running

	pod spec lint Peanut.podspec
	
If everything is fine you'll read

	pod spec lint Peanut.podspec 
	-> Peanut (1.0.0)
	Analyzed 1 podspec.
	Peanut.podspec passed validation.

Otherwise <code>pod spec</code> will explain the error or warning, as everything is so simple also fixing the problems will be. Anyway the error report is already formatted in <a href="http://daringfireball.net/projects/markdown/">Markdown</a> so you can copy it and paste it in an issue on the <a href="https://github.com/CocoaPods/CocoaPods/issues/new">CocoaPods Issues page</a>.
<h3>Step 6 - Let your pod fly</h3>
We're almost done here. Now to make our pod available to the community, or just to ourselves and feel cool, we have two options. The rookie way is open an issue, but we've just coded an iOS library, with it's own repo on GitHub, and generated the <code>podspec</code> fetching the data from there, so we're not rookies. The second option is to fork the <a href="https://github.com/CocoaPods/Specs">Specs repo</a>, add our pod, submit the PR and wait.

I submitted my PR at 8:44 GTM+0 on a Sunday<span style="text-decoration:line-through;">, let's see how long it takes to merge it</span>. The PR approved and merged in less that 2 hours. That's what I call efficiency. Also you can ask for push rights, in order to maintain your pod without submitting a pull request every time.

<p>And here we are. My MGCraftman framework is ready to be imported via CocoaPods, and all the world will be happy to use it, or not.</p>

That's all folks, happy coding!

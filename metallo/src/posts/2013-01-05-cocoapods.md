---
date: 2013-01-05
title: CocoaPods!
tags:
- CocoaPods
- git
- iOS
- Objective-C
---

<h2>description: A brief introduction to CocoaPods, the Objective-C dependencies manager.</h2>

<h2>What is CocoaPods?</h2>

<blockquote>
  <p>CocoaPods: The best way to manage library dependencies in Objective-C projects.</p>
</blockquote>

<p>If you're familiar with Ruby on Rails, it's the same thing as <a href="http://gembundler.com/">Bundler</a>, or it's lame copy attempt for Symfony 2, <a href="http://getcomposer.org/">Composer</a>.</p>

<p>If you're not, and you haven't sorted it out from the quote above, CocoaPods is a tool that's let us manage our libraries and their dependencies in our Objective-C projects. This means:</p>

<ol>
<li>No more wasted time downloading all the libraries the one we want to use depends on.</li>
<li>Smart and safe version management, specially when we're working on a project with other people, which is 90% of the time.</li>
</ol>

<p>To <em>"get my hands dirty"</em> with CocoaPods I made this little project called <a href="https://github.com/mokagio/justninegags">JustNineGags</a>, feel free to check it out on GitHub.</p>

<h2>Why should I use it?</h2>

<p>Because it's awesome! It makes development faster and easier, and also safer! It easier to work in teams and keep the libraries versions even. Should I go on? Ok! Just think about this: you won't download and move in your project a library anymore, <code>pod</code> will do it all for you!</p>

<h2>Installing CocoaPods</h2>

<p>Installing CocoaPods is as simple as installing all the other Ruby Gems, I shouldn't even writing this, as what's written in the <a href="http://cocoapods.org/#install">install section</a> is more than enough, anyway:</p>

<div class="highlight"><pre lang="">gem install cocoapods
</pre></div>

<p>Once the installation is completed run:</p>

<div class="highlight"><pre lang="">pod setup
</pre></div>

<p>This will, guess what, setup everything CocoaPods needs on your system. You should see an output like this:</p>

<div class="highlight"><pre lang="">Setting up CocoaPods master repo
Cloning spec repo `master' from `<a href='https://github.com/CocoaPods/Specs.git'>https://github.com/CocoaPods/Specs.git</a>' (branch `master')
Setup completed (read-only access)
</pre></div>

<p>Done! :)</p>

<p><em>You should avoid using <code>sudo</code> otherwise everything else you'll do with <code>pod</code> will need to use <code>sudo</code> as well. And this mean that the folders and file that are gonna be created will be owend by <code>root</code> instead that by you.</em></p>

<h2>Using CocoaPods</h2>

<p>Again, everything written on the <a href="http://cocoapods.org/#get_started">website</a> is pretty straightforward.</p>

<p>Go in the root folder of your Objective-C project and create a file named <code>Podfile</code>, with whatever editor you like. We'll use this file to list all the libraries, <em>pods</em>, we need in the project. The JustNineGags <code>Podfile</code> content is:</p>

<pre><code>
platform :ios
pod 'MBProgressHUD', '~> 0.5'
pod 'Reachability',  '~> 3.1.0'
</code></pre>

<h3>Adding a Pod</h3>

<p>As you can see adding a Pod is really easy, just go on <a href="http://cocoapods.org">CocoaPods website</a>, look for the it, and then add it to the <code>Podfile</code> using it's name and the version you need.</p>

<h3>Installing the Pods</h3>

<p>Right now we've told CocoaPods the Pods we need but they aren't yet in out project. So let's run</p>

<div class="highlight"><pre lang="">pod install
</pre></div>

<p>This will download all the libraries we've asked for, and all their dependencies. Sweet!</p>

<p>The first time we run <code>pod install</code> something else will happen, a <code>Pods/</code> folder, a <code>Podfile.lock</code>, and a <code>YourProjectName.xcworkspace</code> will be created.</p>

<p><strong>Important!</strong> From now on remember to open your project through the <code>YourProjectName.xcworkspace</code> file, otherwise the pods won't be loaded by Xcode.</p>

<p>That's all folks! :)</p>

<h3>What should we track?</h3>

<p>Using CocoaPods adds some files and folders to our project, which of those should we track in our repo, and which should be left aside, adding them to the <code>.gitignore</code>? That of course assuming you're using git, and you definitely should. Let's have a look at the new stuff:</p>

<ul>
<li><code>Podfile</code>, we definitely <b>need</b> this one, as all the pods we need are listed in it.</li>
<li><code>Podfile.lock</code>, as for all the other library management systems, we <b>need</b> this one too, because it's used to assure all the developers are using the same versions of the pods and their dependencies.</li>
<li><code>Pods/</code>, we <b>don't need</b> to track this folder, it's created by <code>pod install</code>, and all it's content is downloaded for us from other repos.</li>
<li><code>YourProjectName.xcworkspace</code>, we <b>don't need</b> this one either, because it's generated by <code>pod install</code> too.</li>
</ul>

<h2>What's coming next?</h2>

<p>How to setup our own pods. I'll probably write a little and simple Category to add other colors to the <code>UIColor</code> factories, stay tuned!</p>

<hr />

<h2>Update 2013-01-06</h2>

<p>To implement HTTP requests in <a href="https://github.com/mokagio/justninegags">JustNineGags</a> I used <code><a href="https://github.com/nfarina/webrequest">SMWebRequest</a></code> because I'm too lazy to write everything by myself. <code>SMWebRequest</code> wasn't a Pod yet so I opened an <a href="https://github.com/nfarina/webrequest/issues/7">issue</a> asking good guy <a href="https://twitter.com/nfarina">nfarina</a> to add it. In less than 12 hours the Pod was added! :D</p>
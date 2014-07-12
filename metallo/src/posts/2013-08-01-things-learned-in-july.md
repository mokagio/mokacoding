---
date: 2013-08-01
title: Some things I learned in July
tags:
- AWS
- iOS
- Objective-C
- Postgres
- Ruby
- Ruby on Rails
- Software Engineering
slug: things-learned-in-july-2013
description: A summary of the things I learned in July 2013.
---

July has been a month dense of learning and (re)discoveries! First of all <strong>Rails 4</strong>, which I come to love back in the day, when I was working with my friends on the first prototype of <a href="http://www.kunerango.com" target="_blank">Kunerango</a>

###Objective-C and iOS Development

<a href="http://rentzsch.github.io/mogenerator/" target="_blank">http://rentzsch.github.io/mogenerator/</a>

Guess what? CoreData doesn't make your life easy when you're seriously working with test, <a href="http://stackoverflow.com/questions/1876568/ocmock-with-core-data-dynamic-properties-problem" target="_blank">http://stackoverflow.com/questions/1876568/ocmock-with-core-data-dynamic-properties-problem</a>. I like the protocol approach, even if it adds a some "boilerplate code" to maintain.

<a href="http://nomad-cli.com/">nomad</a> a set of useful tools to automate the every-day development. Another gift from mister <a href="http://mattt.me/">Mattt</a>.

###Ruby on Rails

<a href="http://rubyonrails.org/" target="_blank">Rails 4</a> finally out! <a href="http://weblog.rubyonrails.org/2013/6/25/Rails-4-0-final/" target="_blank">http://weblog.rubyonrails.org/2013/6/25/Rails-4-0-final/</a>

Nice and clear guide to testing with RSpec on Rails <a href="http://everydayrails.com/2012/03/12/testing-series-rspec-setup.html" target="_blank">http://everydayrails.com/2012/03/12/testing-series-rspec-setup.html</a>

Binstubs, because the less we type, the better! <a href="http://blog.barbershoplabs.com/blog/2013/03/01/upgrading-to-rails-40-binstubs" target="_blank">http://blog.barbershoplabs.com/blog/2013/03/01/upgrading-to-rails-40-binstubs</a>, <a href="http://mislav.uniqpath.com/2013/01/understanding-binstubs/" target="_blank">http://mislav.uniqpath.com/2013/01/understanding-binstubs/</a>, <a href="http://robots.thoughtbot.com/post/15346721484/use-bundlers-binstubs" target="_blank">http://robots.thoughtbot.com/post/15346721484/use-bundlers-binstubs</a>

The <a href="https://github.com/indirect/haml-rails">haml-rails</a> gem integrates with the template generators, out of the box!

How cool are named routes? <code>post 'items/move_down/:id' =&gt; 'items#move_down', as: :move_down )</code>, look at the routes.rb comments to know more about them.

Amazon AWS S3 gem <a href="http://amazon.rubyforge.org">http://amazon.rubyforge.org</a>

I found a nice gem to add enumeration type to the ActiveRecord models: <a href="https://github.com/adzap/active_enum">active_enum</a>, but is it compatible with Rails 4? Here's a [link](http://qubitlogs.com/Rails/2013/02/01/creating-pre-defined-set-of-attributes-mapping-integers-to-strings-in-rails/#.UdWbpT6DQ_U) on how to use it.

###Ruby

I wrote some scripts to speed up some of my daily task at work, and used some nice gems in the meantime:
<a href="http://nokogiri.org/">nokogiri</a>, to parse HTML using CSS selectors
<a href="https://github.com/rest-client/rest-client">rest-client</a>, fetching pages from the web with one line of code
<a href="http://rubygems.org/gems/json">json</a>, to parse JSON
<a href="https://github.com/samg/diffy">diffy</a>, comparing strings has never been so easy
<a href="https://github.com/mikel/mail">mail</a>, sending emails from your scripts

###Coding Recipes

<a href="http://codeartists.com/post/36892733572/how-to-directly-upload-files-to-amazon-s3-from-your">http://codeartists.com/post/36892733572/how-to-directly-upload-files-to-amazon-s3-from-your</a>

<a href="http://codeartists.com/post/36892733572/how-to-directly-upload-files-to-amazon-s3-from-your">http://quickleft.com/blog/keeping-your-json-response-lean-in-rails</a>

<a href="http://stackoverflow.com/questions/3159945/running-command-line-commands-within-ruby-script">Several ways to run a command line command from a Ruby script.</a>

###Sysadmin

Fixing Postgres connection error on OS X Mountain Lion <a href="http://jaygoldman.com/2012/11/fixing-postgres-connection-errors-on-mountain-lion/">http://jaygoldman.com/2012/11/fixing-postgres-connection-errors-on-mountain-lion/ </a>(funny because with Node there were no problems)

###Javascript

I looked into a bunch of Javasciprt techs: <a href="http://underscorejs.org/">Underscore.js</a>, <a href="http://jade-lang.com/">Jade</a>, <a href="http://handlebarsjs.com/">Handlebars</a>, <a href="http://learnboost.github.io/stylus/">Stylus</a>, <a href="http://expressjs.com/">Express</a>

###Tools

<a href="http://imageoptim.com/">http://imageoptim.com/</a>

###Software Engineering Good Practices

<a href="http://en.wikipedia.org/wiki/Coupling_(computer_programming)">Coupled dependencies</a>, I found one of those monsters in a colleague's code. It took a lot of self-control to avoid being a prick and pointing it out on GitHub.

###Interesting readings

<a href="How Basecamp Next got to be so damn fast without using much client-side UI">How Basecamp Next got to be so damn fast without using much client-side UI</a>

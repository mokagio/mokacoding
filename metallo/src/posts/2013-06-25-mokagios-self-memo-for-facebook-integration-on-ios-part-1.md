---
date: 2013-06-25
title: mokagio's self memo for Facebook Integration on iOS - Part 1
tags:
- CocoaPods
- Facebook
- iOS
- Objective-C
slug: ios-facebook-integration-part-1
description: "Step by step guide on how to integrate the Facebook SDK in an iOS app, the right way. Part 1: Facebook Login."
---

##Part 1 - Facebook Login

###0 - Create a Facebook App

Create an app on the <a href="https://developers.facebook.com/apps/">Facebook App Dashboard</a>, what are you gonna integrate otherwise?!

###1 - Add the Facebook SDK Pod

Given that you have already setup your libraries management with CocoaPods, and you should have, add to your `Podfile` the line

  pod "Facebook-iOS-SDK", "~&gt; 3.5.2"


Then run `pod install`.

For more info about how to use CocoaPods check out <a href="http://amokafullofstuff.wordpress.com/2013/01/05/cocoapods/">this</a> post of mine.

###2 - Add some Facebook data to the `Info.plist`

Facebook requires you to add two fields to your `Info.plist` file:

* **FacebookAppID**: a 15 digits number you can find in the Settings page of your app on your Facebook developer page.
* **FacebookDisplayName**: how to comment, the display name of your app?

###3 - A basic login flow

The <a href="https://developers.facebook.com/docs/tutorials/ios-sdk-tutorial/">tutorial</a> tells us to put all the Facebook login in the `AppDelegate`. I don't like this approach, because I don't want to make the delegate dirty with code related only to Facebook. I prefer to create a `FacebookProxy` class, with class methods to call to interact with Facebook.

Whatever solution you prefer the steps for the login are the same anyway:

1. Check if the user is logged already. Let's assume he isn't…
2. Present in some way a call to action for the Facebook Login.
3. Call the Facebook SDK method to login the user.
4. Let the SDK do it's job.
5. Come back to the app and handle the result.

####Check if the user is logged in

To get the current Facebook session we use `FBSession.activeSession`. To see if the session is active, and therefore the user is already logged in, we need to check the `state` property: `FBSession.activeSession.state`. A quick look to the `typedef enum` of the `FBSessionState` and:

	{% highlight objective-c %}
	+ (BOOL)isUserLoggedInFacebook
	{
	    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded
	        || FBSession.activeSession.state == FBSessionStateOpen
	        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
	        return YES;
	    } else {
	        return NO;
	    }
	}
	{% endhighlight %}

####Call the Facebook SDK method to login

Easy peasy:

	{% highlight objective-c %}
	[FBSession openActiveSessionWithReadPermissions:nil
	                                   allowLoginUI:YES
	                              completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
	     // handle stuff here
	 }];
	 {% endhighlight %}

In the completion handler we should… handle the result of the open active session. I think that this really depends on what our app will do, so I'm not gonna write any snippet here.

####Come back to the app and handle the result

If you're user's are using iOS 5 -I hope they're not-, or if they're so dumb they haven't installed the native Facebook app for iOS, the login will occur with a sort of modal window in your app. In all the rest of the cases the

###Frameworks needed in the Test Bundle
TDD is the way. Full stop. I noticed that adding the Facebook-iOS-SDK pod to my project wasn't enough for my test bundle to run, there were some framework dependencies missing:

* AdSupport.framework
* Social.framework

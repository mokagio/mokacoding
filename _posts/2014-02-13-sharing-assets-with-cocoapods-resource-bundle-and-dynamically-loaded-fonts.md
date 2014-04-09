---
layout: post
title: Sharing assets across iOS projects with CocoaPods, Resource Bundle, and dynamically loaded fonts
seo_description: Showing an approach to centralize resources, assets, and fonts across multiple projects using CocoaPods, a Resource Bundle and a bit of code
keyword: iOS, CocoaPods, Images, Fonts, Assets, Resources
published: true
categories:
- Workflow
tags:
- iOS 
- Architecture
- Productivity
---

It is useful and time saving to centralize all the resources, assets and fonts that are shared across different projects. The best solution for that is [CocoaPods](http://cocoapods.org/), and a bit of code to avoid doing any kind on `Info.plist` update.

If you can't be bothered reading the post, and want to look at some code straightaway checkout [this example](https://github.com/mokagio/mokacoding-samples/tree/master/ResourceBundlePodExample) I've made.

The process is very simple:

1. Create the pod
2. Add the resources to the pod resource bundle
3. Dynamically load the fonts

Creating a pod is super simple, I already [wrote about it](http://www.mokacoding.com/2013/01/21/cocoapods-how-to-create-your-own-pod.html), but it was a while ago, the best place to look for it is the [official CocoaPod documentation](http://guides.cocoapods.org/making/specs-and-specs-repo.html).

### Add the assets to the pod resource bundle

Since version [0.23.0](https://github.com/CocoaPods/CocoaPods/blob/master/CHANGELOG.md#0230rc1) the Spec DSL has a `resource_bundle` attribute, and it's recommended to use it instead of the old `resources`, to avoid potential name clashes with other pods or libraries.

But what's a resource bundle? As usual the [Apple Documentation](https://developer.apple.com/library/ios/documentation/CoreFoundation/Conceptual/CFBundles/Introduction/Introduction.html) is not very clear, but we could define a bundle as _a folder with an extension, conforming to some rules for it's content_. 

Then how do we make a bundle? Or in our case a Resource Bundle, so that we can add it in our `.podspec`? As you can imagine the Documentation is still not helpful...

I spent a couple of hours messing around creating folders naming the `folder.bundle`, googling and [stackoverflowing](http://stackoverflow.com/questions/8458953/ios-build-a-resource-bundle-via-xcode-target), but with no luck integrating it with my pod. I also found a [tutorial](http://www.galloway.me.uk/tutorials/ios-library-with-resources/) by Matt Galloway, but it looked like a complex hack, there had to be something simpler!

Turns out it's **dead simple**! Just list the resources path you want in the bundle and the pod will generate it for you. Boom. No tricks, no hacks, just a line of code.

```ruby
spec.ios.resource_bundle = { 'MapBox' => 'MapView/Map/Resources/*.png' }
```

### Dynamically load the fonts

Now that the we have our Resource Bundle ready we only need to skip the annoying process of adding the fonts to the `Info.plist` and we're good to go.

To do that I used the approach suggested by Marco Armet in [this blog post](http://www.marco.org/2012/12/21/ios-dynamic-font-loading). It's possible to dynamically load fonts and then consume them with the usual `fontNamed:withSize` `UIFont` class method.

```objc
NSData *inData = /* your decrypted font-file data */;
CFErrorRef error;
CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)inData);
CGFontRef font = CGFontCreateWithDataProvider(provider);
if (! CTFontManagerRegisterGraphicsFont(font, &error)) {
    CFStringRef errorDescription = CFErrorCopyDescription(error)
    NSLog(@"Failed to load font: %@", errorDescription);
    CFRelease(errorDescription);
}
CFRelease(font);
CFRelease(provider);
```

The only downside of this approach is that we need to run that code at some point. I put it into a `FontsManager` class, with getters for the fonts that sort of lazy loads them. Like this:

```objc
static NSString * const kBundle = @"ResourceBundle.bundle";

+ (UIFont *)openSansLightFontOfSize:(CGFloat)size
{
    NSString *fontName = @"OpenSans-Light";
    UIFont *font = [UIFont fontWithName:fontName size:size];
    if (!font) {
        [[self class] dynamicallyLoadFontNamed:fontName];
        font = [UIFont fontWithName:fontName size:size];
        
        // safe fallback
        if (!font) font = [UIFont systemFontOfSize:size];
    }
    
    return font;
}

+ (void)dynamicallyLoadFontNamed:(NSString *)name
{
    NSString *resourceName = [NSString stringWithFormat:@"%@/%@", kBundle, name];
    NSURL *url = [[NSBundle mainBundle] URLForResource:resourceName withExtension:@"ttf"];
    NSData *fontData = [NSData dataWithContentsOfURL:url];
    if (fontData) {
        CFErrorRef error;
        CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)fontData);
        CGFontRef font = CGFontCreateWithDataProvider(provider);
        if (! CTFontManagerRegisterGraphicsFont(font, &error)) {
            CFStringRef errorDescription = CFErrorCopyDescription(error);
            NSLog(@"Failed to load font: %@", errorDescription);
            CFRelease(errorDescription);
        }
        CFRelease(font);
        CFRelease(provider);
    }
}
```

### What about the images?

We can access images with the same strategy used for the fonts, a manager that lazy loads them from the bundle.

---

Having a tidy project is invaluable, specially when it only needs a couple of lines of code. Plus by grouping our assets in a pod we can quickly implement other apps with a style consistent to our branding. 

If you're interested in the matter of handling big projects by modularizing them, [this](http://dev.hubspot.com/blog/architecting-a-large-ios-app-with-cocoapods) article will be an interesting read.

_Leave your codebase better than you found it_


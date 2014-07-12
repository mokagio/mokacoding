---
date: 2013-10-31
title: A dive into Xcode projects and workspaces
tags:
- Xcode
- iOS
- Objective-C
- Questions
- Hacking
description: A look at how Xcode stores information about the project and the workspace
keyword: Xcode project workspace
slug: xcode-projects-and-workspaces
---

_Note: this is post is the first answer to my [October's Questions](http://www.mokacoding.com/blog/october-questions). It should have arrived earlier but this month has been strange, because of several reasons I didn't had and didn't make enough time to write. But let's get started!_

I use Xcode every day (what an happy life), and it has now come the time to dig deeper into this pain in the butt of an IDE. Where to start if not from the _merge nightmare_, the `project.pbxproj`.

`project.pbxproj` is contained into `YourProjectName.xcodeproj`, which is nothing more than a folder. It might be interesting to explore the rest of the content, but for now let's just focus on the `.pbxproj`.

The [Apple Documentation](https://developer.apple.com/library/ios/featuredarticles/XcodeConcepts/Concept-Projects.html#//apple_ref/doc/uid/TP40009328-CH5-SW1) sais:

> An Xcode project is a repository for all the files, resources, and information required to build one or more software products. A project contains all the elements used to build your products and maintains the relationships between those elements. It contains one or more targets, which specify how to build products. A project defines default build settings for all the targets in the project (each target can also specify its own build settings, which override the project build settings).
 
Cool, I got that, but what about the file itself? Let's open one with a text editor. I've used the `project.pbxproj` from [KZPropertyMapper](https://github.com/krzysztofzablocki/KZPropertyMapper/blob/master/Example/Example.xcodeproj/project.pbxproj) a smart and timesaving library that you should all checkout.

It appears as a sort of JSON, written in C, as it as a `{}` hierarchy, with inside `=`, `;` and `/* inline comments */`.

The top level is something like

```
// !$*UTF8*$!
{
	archiveVersion = 1;
	classes = {
	};
	objectVersion = 46;
	objects = {
		...
	};
	rootObject = CDAC62FA17A0EF1A00F5452A /* Project object */;
}
```

The `objects` part is the real deal. Everything about the project is in there. All stored again in a dictionary fashion, with hexadecimal identifiers. A common parameter is the `isa` key. Here's an example:

```
CDAC634017A0EF4C00F5452A /* KZPropertyMapper.m in Sources */ = {
	isa = PBXBuildFile; 
	fileRef = CDAC633F17A0EF4C00F5452A /* KZPropertyMapper.m */;
};
```

Lucky for us Xcode adds some comments to make the things a bit more readable for humans. _Note:_ I'm sure they're comment and not part of the way stuff is written because I actually tried changing one and everything run fine.

The `objects` has many sections, each wrapped between `/* Begin SectionName section */` and `/* End SectionName section */` comments. 

Here's the ones I found more interesting, the [xcodeproj](http://docs.cocoapods.org/xcodeproj/index.html) gem documentation used by [CocoaPods](http://cocoapods.org/) has been really helpful in understanding what some sections were about:

####`PBXFileReference`

All the files in the project are in this list.

```
CDAC633F17A0EF4C00F5452A /* KZPropertyMapper.m */ = {
	isa = PBXFileReference;
	fileEncoding = 4; 
	lastKnownFileType = sourcecode.c.objc; 
	path = KZPropertyMapper.m; 
	sourceTree = "<group>"; 
};
```

####`PBXGroup`

This section has the groups tree. The groups are those fake folders that are useful only to create confusion on how the filesystem is oraganized. A PBXGroup can contain `PBXFirleReference`s, as well as other `PBXGroup`s. 

####`PBXNativeTarget`

In this section we have the settings of the _Targets_ of the project, in particular there's references to `buildPhases` and `buildRules`, like in the UI.

####`PBXShellScriptBuildPhase`

Here we have the settings for a _Build Phase_ of type _Run Script_. The funny thing about this part is that the script you insterted in the text box is stored as a one string…

####`PBXVariantGroup`

I found it hard to guess from the name, but here we have the information about the localized files.

That's it, more or less… The `project.pbxproj` file stores all the informations regarding the project we're working on, and it's organized in a lot of meaningful sections related together by keeping track of the objects identifiers in form of hex hashes. Let's move on to the workspace then.

I first came across an Xcode workspace when I used [Kobold2d](http://www.kobold2d.com/display/KKSITE/Home) to develop a simple and unsuccesful game of iOS. It's easy to guess what a workspace might be. 

The [Apple Documentation](https://developer.apple.com/library/ios/featuredarticles/XcodeConcepts/Concept-Workspace.html) sais:

> A workspace is an Xcode document that groups projects and other documents so you can work on them together. A workspace can contain any number of Xcode projects, plus any other files you want to include. In addition to organizing all the files in each Xcode project, a workspace provides implicit and explicit relationships among the included projects and their targets.

The `.xcworkspace` from [KZPropertyMapper](https://github.com/krzysztofzablocki/KZPropertyMapper/tree/master/Example/Example.xcworkspace) is too tiny, so let's  take a look at another one, [AFNetworking](https://github.com/AFNetworking/AFNetworking/blob/master/AFNetworking.xcworkspace/contents.xcworkspacedata). As for the project the workspace is nothing but a folder, grouping configuration files. The interesting file here is `contents.xcworkspacedata`. Let's open it… Surprise! Unlike the project file this one is a more readable [XML](http://en.wikipedia.org/wiki/XML). Inside there's a list of the workspace components. 

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Workspace
	version = "1.0">
	<Group
		location = "group:AFNetworking"
		name = "AFNetworking">
		<FileRef
			location = "group:AFNetworking.h">
		</FileRef>
		<Group
			location = "container:"
			name = "NSURLConnection">
			<FileRef
				location = "group:AFNetworking/AFURLConnectionOperation.h">
			</FileRef>
			...
		</Group>
		<Group
			location = "container:"
			name = "NSURLSession">
			...
		</Group>
		...
	</Group>
	...
	<FileRef
		location = "group:Tests/AFNetworking Tests.xcodeproj">
	</FileRef>	
	...
</Workspace>
```

If you open the `AFNetworking.xcworkspace` you'll see this

<!-- I know, I know... inline style is shit :(-->
<img src="http://mokacoding.s3.amazonaws.com/2013-10-31-afnetworking_fs.png" style="width: 200px" alt="AFNetworking Workspace"/>

It all then comes together. It works more or less as the `project.pbxproj` does. The `Group` tag contains other `Group`s or `FileRef` tags, which represent where the file is in the filesystem related to the location of the workspace.

This is it. Of course there could be, and may be there will be, a lot more to dig and look into, but for tonight I'm fine with this. I now have a clearer picture of what happens when I add a new file to a project or I use the GUI to edit the configurations of a target. I can't say this is gonna make my everyday battle with Xcode easier, but definitely knowing more of how it works makes me feel smarted.

Happy coding.

###References

* The [xcodeproj](http://docs.cocoapods.org/xcodeproj/index.html) gem used by [CocoaPods]().
* [xcoder](https://github.com/rayh/xcoder), another gem to manipulate an Xcode project. 
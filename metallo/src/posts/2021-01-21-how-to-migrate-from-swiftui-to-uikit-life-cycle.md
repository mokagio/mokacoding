---
title: How to migrate from SwiftUI to UIKit App Delegate Life Cycle in Xcode
description: This free tutorial shows how to migrate an existing app with SwiftUI life cycle to use UIKit App Delegate instead
tags:
- SwiftUI
- Xcode
og_image: https://s3.amazonaws.com/mokacoding/2021-01-15-ogcover.jpg
---

This brief tutorial shows how to convert a SwiftUI app from the SwiftUI to the UIKit App Delegate life cycle in Xcode.

Unfortunately, there is no Xcode wizard to do this.
Still, the process is straightforward – once you know which files to update.

You can find the sample project for this tutorial on [GitHub](https://github.com/mokagio/SwiftUItoUIKit/).
The [commits history](https://github.com/mokagio/SwiftUItoUIKit/commits/trunk) shows the diff for each step.

### Step 0 - Extract root view from SwiftUI `App`

All the layout configuration from your SwiftUI `App` will be lost once UIKit manages the life cycle.
Before we begin, extract your current root view in a dedicated `View`, so you'll have all your existing UI ready to go after the conversion.

For example, let's say your `App` looks like this:

```swift
struct ExampleApp: App {

    var body: some Scene {
        WindowGroup {
            VStack(alignment: .center, spacing: 8) {
                Text("Lorem")
                Text("Ipsum")
            }
        }
    }
}
```

To retain all the existing root view SwiftUI, extract the `VStack` into a dedicated `View`:

```swift
struct RootView: View {

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("Lorem")
            Text("Ipsum")
        }
    }
}

struct ExampleApp: App {

    var body: some Scene { WindowGroup { RootView() } }
}
```

### Step 1 - Create a `UIApplicationDelegate`

If you want to use the UIKit App Delegate life cycle, you'll need a `UIApplicationDelegate` to begin with.
Here's a template for a minimal one you can use as your starting point:

```swift
// AppDelegate.swift
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
```

If you build your app now, you won't see any difference because `AppDelegate` is unused.

### Step 2 - Create a `UIWindowSceneDelegate`

As per [Apple's documentation](https://developer.apple.com/documentation/uikit/uiwindowscenedelegate), `UIWindowSceneDelegate` is where you "manage the life cycle of one instance of your app's user interface" and "receive notifications when its scene connects to the app, enters the foreground, and so on."
It's where you instantiate your UI.

Here's a template for a minimal one you can use as your starting point:

```swift
// SceneDelegate.swift
import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let rootView = RootView()

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UIHostingController(rootView: rootView)
        self.window = window
        window.makeKeyAndVisible()
    }
}
```

Like `AppDelegate`, this code is currently unused.
We'll take care of this in the next step.

### Step 3 - Update `Info.plist` `UIApplicationSceneManifest` & `@main`

With a `UIApplicationDelegate` and `UIWindowSceneDelegate` in place, it's finally time to tell Xcode to use them for the app's life cycle.

Got in your app target "Info" section and update the "Application Scene Manifest" from this:

![screenshot of Application Scene Manifest for SwiftUI life cycle app](https://s3.amazonaws.com/mokacoding/2021-01-21-info-plist-before.jpg)

To this:

![screenshot of Application Scene Manifest for UIKit App Delegate life cycle app](https://s3.amazonaws.com/mokacoding/2021-01-21-info-plist-after.jpg)

If you're like me and like to work with text files instead of GUIs, you can edit the `Info.plist` directly. From this:

```xml
<key>UIApplicationSceneManifest</key>
<dict>
  <key>UIApplicationSupportsMultipleScenes</key>
  <true/>
</dict>
```

To this:

```xml
<key>UIApplicationSceneManifest</key>
<dict>
  <key>UIApplicationSupportsMultipleScenes</key>
  <false/>
  <key>UISceneConfigurations</key>
  <dict>
    <key>UIWindowSceneSessionRoleApplication</key>
    <array>
      <dict>
        <key>UISceneConfigurationName</key>
        <string>Default Configuration</string>
        <key>UISceneDelegateClassName</key>
        <string>$(PRODUCT_MODULE_NAME).SceneDelegate</string>
      </dict>
    </array>
  </dict>
</dict>
```

Updating the `Info.plist` will get the OS to load the correct object at runtime, but the app is still configured to use the SwiftUI `App` implementation as the main entry point.

You can make your new `AppDelegate` the app's entry point by moving the `@main` annotation to it.

```swift
// AppDelegate.swift
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    // ...
}
```

That's it.

To verify the setup works, add a breakpoint to `application(_:, didFinishLaunchingWithOptions:)` or `scene(_:, willConnectTo:, options:)` and launch the app, the execution should pause there.

Enjoy your UIKit App Delegate life cycle.

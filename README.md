# Uplift - Cornell Fitness

<p align="center"><img src=https://raw.githubusercontent.com/cuappdev/uplift-ios/master/Uplift/Assets.xcassets/AppIcon.appiconset/ItunesArtwork%402x.png width=210 /></p>

Uplift is one of the latest apps by [Cornell AppDev](http://cornellappdev.com), an engineering project team at Cornell University focused on mobile app development. Uplift aims to be the go-to fitness and wellness tool that provides information and class times for gym resources at Cornell. Download the current release on the [App Store](https://apps.apple.com/bn/app/uplift-cornell-fitness/id1439374374)!

## Development

### 1. Installation
We use [CocoaPods](http://cocoapods.org) for our dependency manager. This should be installed before continuing.

To access the project, clone the project, and run `pod install` in the project directory.

### 2. Configuration (optional)
We use [Fabric](https://fabric.io) and Crashlytics for our user analytics. To run the project without a Fabric account, comment out this line in `AppDelegate.swift`:
```swift
Crashlytics.start(withAPIKey: Keys.fabricAPIKey.value)
```

Otherwise, to build the project, you need a `Secrets/Keys.plist` file in the project in order to use Fabric / Crashlytics:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>fabric-api-key</key>
	<string>INSERT_API_KEY</string>
	<key>fabric-build-secret</key>
	<string>INSERT_BUILD_SECRET</string>
</dict>
</plist>

```

Finally, open `Uplift.xcworkspace` and enjoy Uplift!

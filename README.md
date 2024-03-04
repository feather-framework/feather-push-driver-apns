# Feather Push Driver APNS

A push driver for the Feather CMS Push component using Swift APNS.

## Getting started

⚠️ This repository is a work in progress, things can break until it reaches v1.0.0. 

Use at your own risk.

### Adding the dependency

To add a dependency on the package, declare it in your `Package.swift`:

```swift
.package(url: "https://github.com/feather-framework/feather-push-driver-apns.git", .upToNextMinor(from: "0.2.0")),
```

and to your application target, add `FeatherPushDriverAPNS` to your dependencies:

```swift
.product(name: "FeatherPushDriverAPNS", package: "feather-push-driver-apns")
```

Example `Package.swift` file with `FeatherPushDriverAPNS` as a dependency:

```swift
// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "my-application",
    dependencies: [
        .package(url: "https://github.com/feather-framework/feather-push-driver-apns.git", .upToNextMinor(from: "0.2.0")),
    ],
    targets: [
        .target(name: "MyApplication", dependencies: [
            .product(name: "FeatherPushDriverAPNS", package: "feather-push-driver-apns")
        ]),
        .testTarget(name: "MyApplicationTests", dependencies: [
            .target(name: "MyApplication"),
        ]),
    ]
)
```

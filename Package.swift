// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "feather-push-driver-apns",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
    ],
    products: [
        .library(name: "FeatherPushDriverAPNS", targets: ["FeatherPushDriverAPNS"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-server-community/APNSwift.git", from: "5.0.0"),
        .package(url: "https://github.com/feather-framework/feather-push.git",
            .upToNextMinor(from: "0.2.0")
        ),
    ],
    targets: [
        .target(
            name: "FeatherPushDriverAPNS",
            dependencies: [
                .product(name: "FeatherPush", package: "feather-push"),
                .product(name: "APNS", package: "APNSwift"),
            ]
        ),
        .testTarget(
            name: "FeatherPushDriverAPNSTests",
            dependencies: [
                .product(name: "FeatherPush", package: "feather-push"),
                .product(name: "XCTFeatherPush", package: "feather-push"),
                .target(name: "FeatherPushDriverAPNS"),
            ]
        ),
    ]
)

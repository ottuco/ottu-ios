// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "ottu_checkout_sdk",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "ottu_checkout_sdk",
            targets: ["ottu_checkout_sdk"]
        ),
        .library(
            name: "ottu_checkout_sdk_sentry",
            targets: ["ottu_checkout_sdk_sentry"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "ottu_checkout_sdk",
            url: "https://github.com/ottuco/ottu-ios/releases/download/2.2.12-no-deps-8/ottu_checkout_sdk.xcframework.zip",
            checksum: "c8b4e81419188c713309aab57ff4c01eb7649ac3aeac05e387a610f54ee255f8"
        ),
        .binaryTarget(
            name: "ottu_checkout_sdk_sentry",
            url: "https://github.com/ottuco/ottu-ios/releases/download/2.2.12-no-deps-8/ottu_checkout_sdk_sentry.xcframework.zip",
            checksum: "344f54fc0b3abeff42a5f5044164cdddd493272265999e1b57d60b8e426e7a8f"
        )
    ]
)
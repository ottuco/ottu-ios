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
            url: "https://github.com/ottuco/ottu-ios/releases/download/2.2.12-no-deps-6/ottu_checkout_sdk.xcframework.zip",
            checksum: "5d96849ad1b4d3b4c5411d9bbdbaa56c86251581f986ffe855df7a159a83ca99"
        ),
        .binaryTarget(
            name: "ottu_checkout_sdk_sentry",
            url: "https://github.com/ottuco/ottu-ios/releases/download/2.2.12-no-deps-6/ottu_checkout_sdk_sentry.xcframework.zip",
            checksum: "ed5559912955dedcef42f2113a0a7fcba8777c498d90b0f22f0153ac60d8b0a6"
        )
    ]
)
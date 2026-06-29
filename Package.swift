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
            path: "Sources/ottu_checkout_sdk.xcframework"
        ),
        .binaryTarget(
            name: "ottu_checkout_sdk_sentry",
            path: "Sources/ottu_checkout_sdk_sentry.xcframework"
        )
    ]
)
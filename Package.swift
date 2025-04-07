// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "ottu_checkout_sdk",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "ottu_checkout_sdk",
            targets: ["ottu_checkout_sdk", "ottu_checkout_sdk_dep"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/getsentry/sentry-cocoa", from: "8.46.0")
    ],
    targets: [
        .binaryTarget(
            name: "ottu_checkout_sdk",
            path: "./Sources/ottu_checkout_sdk.xcframework"
        ),
        .target(
            name: "ottu_checkout_sdk_dep",
            dependencies: [
                         .product(name: "Sentry", package: "sentry-cocoa")
                     ]
        )
    ]
)

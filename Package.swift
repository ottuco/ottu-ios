// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "ottu_checkout_sdk_sentry",
    platforms: [
        .iOS(.v15)
    ],
    products: [
    	.library(
            name: "ottu_checkout_sdk_sentry",
            targets: ["ottu_checkout_sdk_sentry_wrapper"]
        )
    ],

    dependencies: [
        .package(url: "https://github.com/getsentry/sentry-cocoa", from: "9.0.0")
    ],

    targets: [
        .binaryTarget(
            name: "ottu_checkout_sdk_sentry",
            path: "./Sources/ottu_checkout_sdk_sentry.xcframework"
        ),

        .target(
            name: "ottu_checkout_sdk_sentry_wrapper",
            dependencies: [
                "ottu_checkout_sdk_sentry",
                .product(name: "Sentry", package: "sentry-cocoa")
            ]
        )
    ]
)
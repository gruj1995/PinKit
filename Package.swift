// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PinKit",
    platforms: [
        .iOS(.v15),
        .macOS(.v10_15),
    ],
    products: [
        .library(name: "PinCore", targets: ["PinCore"]),
        .library(name: "PinNetwork", targets: ["PinNetwork"])
    ],
    dependencies: [
        .package(url: "https://github.com/Moya/Moya", .upToNextMajor(from: "15.0.3"))
    ],
    targets: [
        .target(
            name: "PinCore",
            path: "PinCore/Sources"
        ),
        .testTarget(
            name: "PinCoreTests",
            dependencies: ["PinCore"],
            path: "PinCore/Tests"
        ),
        .target(
            name: "PinNetwork",
            dependencies: [
                "PinCore",
                .product(name: "Moya", package: "Moya"),
            ],
            path: "PinNetwork/Sources"
        )
    ]
)

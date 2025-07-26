// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PinKit",
    platforms: [
        .iOS(.v16),
        .watchOS(.v8),
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "PinCore", targets: ["PinCore"]),
        .library(name: "PinModule", targets: ["PinModule"]),
        .library(name: "PinNetwork", targets: ["PinNetwork"])
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Kingfisher", exact: "7.12.0"),
        .package(url: "https://github.com/Moya/Moya", exact: "15.0.3"),
        .package(url: "https://github.com/hmlongco/Factory", exact: "2.5.3"),
        .package(url: "https://github.com/liamnichols/xcstrings-tool-plugin.git", exact: "1.2.0"),
        .package(url: "https://github.com/A-pen-app/AssetsConstantPlugin", exact: "1.0.0")
    ],
    targets: [
        .target(
            name: "PinCore",
            dependencies: [
                .product(name: "Kingfisher", package: "Kingfisher")
            ],
            path: "PinCore/Sources",
            resources: [
                .process("Resources") // 資源資料夾名稱
            ]
        ),
        .target(
            name: "PinModule",
            dependencies: [
                "PinCore",
                "PinNetwork",
                .product(name: "Factory", package: "Factory")
            ],
            path: "PinModule/Sources",
            resources: [
                .process("Resources") // 資源資料夾名稱
            ],
            plugins: [
                .plugin(name: "XCStringsToolPlugin", package: "xcstrings-tool-plugin"),
                .plugin(name: "AssetsConstantPlugin", package: "AssetsConstantPlugin")
            ]
        ),
        .target(
            name: "PinNetwork",
            dependencies: [
                "PinCore",
                .product(name: "Moya", package: "Moya")
            ],
            path: "PinNetwork/Sources"
        )
    ]
)

// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "script",
    platforms: [
           .macOS(.v11)
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.4.0")
    ],
    targets: [
        .executableTarget(
            name: "script",
            dependencies: [
                           .product(name: "ArgumentParser", package: "swift-argument-parser")]),
        .target(
            name: "core",
            dependencies: []),
        .testTarget(
            name: "scriptTests",
            dependencies: ["script"]),
    ]
)

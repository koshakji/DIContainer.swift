// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DIContainer",
    products: [
        .library(
            name: "DIContainer",
            targets: ["DIContainer"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "DIContainer",
            dependencies: []),
        .testTarget(
            name: "DIContainerTests",
            dependencies: ["DIContainer"]),
    ]
)

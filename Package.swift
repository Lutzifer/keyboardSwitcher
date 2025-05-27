// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "keyboardSwitcher",
    platforms: [
        .macOS(.v10_13),
    ],
    products: [
        .executable(name: "keyboardSwitcher", targets: ["keyboardSwitcher"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "keyboardSwitcher"
        ),
    ]
)

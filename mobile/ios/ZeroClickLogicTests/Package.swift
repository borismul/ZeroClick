// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "ZeroClickLogic",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "ZeroClickLogic", targets: ["ZeroClickLogic"]),
    ],
    targets: [
        .target(
            name: "ZeroClickLogic",
            path: "Sources/ZeroClickLogic"
        ),
        .testTarget(
            name: "ZeroClickLogicTests",
            dependencies: ["ZeroClickLogic"],
            path: "Tests/ZeroClickLogicTests"
        ),
    ]
)

// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "ThunderCollection",
    platforms: [
        .iOS("18.0")
    ],
    products: [
        .library(
            name: "ThunderCollection",
            type: .dynamic,
            targets: ["ThunderCollection"]
        )
    ],
    targets: [
        .target(
            name: "ThunderCollection",
            path: "Sources/ThunderCollection"
        ),
        .testTarget(
            name: "ThunderCollectionTests",
            dependencies: ["ThunderCollection"],
            path: "Tests/ThunderCollectionTests"
        )
    ]
)

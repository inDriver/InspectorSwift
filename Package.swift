// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Inspector",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "Inspector", targets: ["Inspector"]),
    ],
    targets: [
        .binaryTarget(
              name: "Inspector",
              url: "https://github.com/inDriver/InspectorSwift/releases/download/3.3.0/InspectorSwift.xcframework.zip",
              checksum: "18e376020613e65e889a09a365745e687025e063dde25f2b655c06c5271da789"
            )
    ]
)

// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "colorlist-imasparql",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/banjun/SwiftSparql", from: "0.11.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "colorlist-imasparql",
            dependencies: ["SwiftSparql"]),
        .testTarget(
            name: "colorlist-imasparqlTests",
            dependencies: ["colorlist-imasparql"]),
    ]
)

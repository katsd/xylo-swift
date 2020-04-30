// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "XyloSwift",
    platforms: [
        .macOS(.v10_14), .iOS(.v12), .tvOS(.v12), .watchOS(.v5)
    ],
    products: [
        .library(
            name: "XyloSwift",
            targets: ["XyloSwift"]),
    ],
    dependencies: [
        .package(name: "Xylo", url: "https://github.com/katsd/xylo", .branch("master")),
    ],
    targets: [
        .target(
            name: "XyloSwift",
            dependencies: ["Xylo"],
            path: "XyloSwift"),
    ],
    cxxLanguageStandard: .cxx1z
)

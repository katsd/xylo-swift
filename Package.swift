// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "XyloSwift",
    products: [
        .library(
            name: "XyloObjC",
            targets: ["XyloObjC"]),
        .library(
            name: "XyloSwift",
            targets: ["XyloSwift"]),
    ],
    dependencies: [
        .package(url: "https://github.com/katsd/xylo", .branch("master"))
    
    ],
    targets: [
        .target(
            name : "XyloObjC",
            dependencies: ["Xylo"],
            path: "XyloObjC"
        ),
        .target(
            name: "XyloSwift",
            dependencies: ["XyloObjC"],
            path: "XyloSwift"),
    ]
)

// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "BinUtils",
   products: [
        .library(name: "BinUtils", targets: ["BinUtils"])
    ],
    targets: [
        .target(
            name: "BinUtils",
            path: "Sources"
        )
    ]
)

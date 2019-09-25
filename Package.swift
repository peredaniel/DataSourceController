// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "DataSourceController",
    products: [
        .library(name: "DataSourceController", targets: ["DataSourceController"]),
    ],
    targets: [
        .target(name: "DataSourceController", path: "DataSourceController"),
    ]
)
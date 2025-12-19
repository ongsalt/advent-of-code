// swift-tools-version: 6.2
// oh come on

import PackageDescription

let package = Package(
  name: "08",
  dependencies: [
    .package(
      url: "https://github.com/apple/swift-collections.git",
      .upToNextMinor(from: "1.3.0")  // or `.upToNextMajor
    )
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .executableTarget(
      name: "08",
      dependencies: [
        .product(name: "Collections", package: "swift-collections")
      ]
    )
  ]
)

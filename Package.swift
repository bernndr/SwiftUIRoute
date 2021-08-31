// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "SwiftUIRoute",
  platforms: [
    .macOS(.v11),
    .iOS(.v14),
    .watchOS(.v7),
    .tvOS(.v14)
  ],
  products: [
    .library(
      name: "SwiftUIRoute",
      targets: ["SwiftUIRoute"]
    )
  ],
  targets: [
    .target(name: "SwiftUIRoute"),
		.testTarget(
      name: "SwiftUIRouteTests",
      dependencies: ["SwiftUIRoute"]
    )
  ]
)

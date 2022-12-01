// swift-tools-version:5.6
import PackageDescription

let package = Package(
  name: "AuthenticationAPI",
  platforms: [.macOS(.v12)]
)

// MARK: - (DEPENDENCIES)

let misc = "LeosMisc"
let vapor = "vapor"

package.dependencies = [
  .package(url: "https://github.com/vapor/\(vapor)", from: "4.0.0"),
  .package(url: "https://github.com/Leo-Lem/\(misc)", branch: "main")
]

// MARK: - (TARGETS)

let api: Target = .executableTarget(
  name: "AuthenticationAPI",
  dependencies: [
    .product(name: "Vapor", package: vapor),
    .byName(name: misc)
  ],
  path: "Sources"
)

let apiTests: Target = .testTarget(
  name: "\(api.name)Tests",
  dependencies: [
    .target(name: api.name),
    .product(name: "XCTVapor", package: vapor)
  ],
  path: "Tests"
)

package.targets = [api, apiTests]

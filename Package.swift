// swift-tools-version:5.6
import PackageDescription

// MARK: - (TARGETS)

let authenticator = Target.target(name: "AuthenticatorAPI")

let app = Target.target(
  name: "AuthenticationAPI",
  dependencies: [
    .target(name: authenticator.name),
    .product(name: "Vapor", package: "vapor")
  ]
)

let executable = Target.executableTarget(
  name: "Run",
  dependencies: [
    .target(name: app.name),
    .target(name: authenticator.name)
  ]
)

let appTests = Target.testTarget(
  name: "\(app.name)Tests",
  dependencies: [
    .target(name: app.name),
    .product(name: "XCTVapor", package: "vapor"),
    .target(name: authenticator.name)
  ]
)

let authenticatorTests = Target.testTarget(
  name: "\(authenticator.name)Tests",
  dependencies: [.target(name: authenticator.name)]
)

// MARK: - (DEPENDENCIES)

let vapor = Package.Dependency.package(url: "https://github.com/vapor/vapor.git", from: "4.0.0")

// MARK: - (PACKAGE)

let package = Package(
  name: app.name,
  platforms: [.macOS(.v12)],
  dependencies: [vapor],
  targets: [authenticator, app, executable, appTests, authenticatorTests]
)

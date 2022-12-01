@testable import AuthenticationAPI
import XCTest

final class AuthenticatorTests: XCTestCase {
  var authenticator: Authenticator!

  override func setUpWithError() throws { authenticator = Authenticator() }

  func testExists() throws {
    let credential = Credential(id: "SomeUser", pin: "SomePin")
    try authenticator.register(credential)
    
    XCTAssertTrue(authenticator.exists(with: credential.id), "ID does not exist after registration")
  }
  
  func testDuplicateRegisteringIsNotAllowed() throws {
    let credential = Credential(id: "SomeUser", pin: "SomePin")
    try authenticator.register(credential)

    XCTAssertThrowsError(try authenticator.register(credential), "Duplicate registration is allowed.")
  }

  func testInvalidIDsAreRefused() throws {
    for id in ["", "asd\n", "an ddd", " "] {
      XCTAssertThrowsError(
        try authenticator.register(Credential(id: id, pin: "SomePin")),
        "Invalid ID (\(id)) is accepted."
      )
    }
  }

  func testAuthenticating() throws {
    let credential = Credential(id: "SomeUser", pin: "SomePin")
    try authenticator.register(credential)

    XCTAssertNoThrow(try authenticator.login(credential))
  }

  func testChangingPIN() throws {
    let credential = Credential(id: "SomeUser", pin: "SomePin")
    try authenticator.register(credential)

    let newPIN = "SomeOtherPin"
    let newCredential = try authenticator.changePIN(credential.attachNewPIN(newPIN))

    XCTAssertNoThrow(try authenticator.login(newCredential), "New PIN (\(newPIN)) is not accepted.")
  }
}

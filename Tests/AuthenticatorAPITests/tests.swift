//	Created by Leopold Lemmermann on 21.11.22.

@testable import AuthenticatorAPI
import XCTest

final class AuthenticatorTests: XCTestCase {
  var authenticator: Authenticator!

  override func setUpWithError() throws {
    authenticator = Authenticator()
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

  func testInvalidPINsAreRefused() throws {
    for pin in ["", "asd", "  "] {
      XCTAssertThrowsError(
        try authenticator.register(Credential(id: "SomeID", pin: pin)),
        "Invalid PIN (\(pin)) is accepted."
      )
    }
  }

  func testAuthenticating() throws {
    let credential = Credential(id: "SomeUser", pin: "SomePin")
    try authenticator.register(credential)

    XCTAssertNoThrow(try authenticator.authenticate(credential))
  }

  func testChangingPIN() throws {
    let credential = Credential(id: "SomeUser", pin: "SomePin")
    try authenticator.register(credential)

    let newPIN = "SomeOtherPin"
    try authenticator.changePIN(credential, newPIN: newPIN)

    let newCredential = Credential(id: credential.id, pin: newPIN)

    XCTAssertNoThrow(
      try authenticator.authenticate(newCredential),
      "New PIN (\(newPIN)) is not accepted."
    )
  }
}

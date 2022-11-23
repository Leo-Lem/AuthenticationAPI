@testable import App
import AppCore
import XCTVapor

final class AuthenticationAPITests: XCTestCase {
  var app: Application!

  override func setUpWithError() throws {
    app = Application(.testing)
    try configure(app, authenticator: Authenticator())
  }
  
  override func tearDownWithError() throws {
    app.shutdown()
  }

  func testRegistering() throws {
    let credential = Credential(id: "SomeUserID", pin: "SomePIN")
    
    try app.test(.POST, "register") { req in
      try req.content.encode(credential)
    } afterResponse: { res in
      XCTAssertEqual(res.status, .ok, "Operation unsuccessful.")
      XCTAssertEqual(try res.content.decode(Credential.self), credential, "Credentials don't match.")
    }
  }

  func testAuthenticating() throws {
    let credential = Credential(id: "SomeUserID", pin: "SomePIN")
    
    try app.test(.POST, "register") { req in
      try req.content.encode(credential)
    }
    
    try app.test(.PUT, "authenticate") { req in
      try req.content.encode(credential)
    } afterResponse: { res in
      XCTAssertEqual(res.status, .ok, "Operation unsuccessful.")
      XCTAssertEqual(try res.content.decode(Credential.self), credential, "Credentials don't match.")
    }
  }

  func testChangingPIN() throws {
    let credential = Credential(id: "SomeUserID", pin: "SomePIN")
    
    try app.test(.POST, "register") { req in
      try req.content.encode(credential)
    }
    
    let credentialWithNewPIN = Credential.WithNewPIN(credential: credential, newPIN: "SomeNewPIN")
    let newCredential = Credential(id: credential.id, pin: credentialWithNewPIN.newPIN)
    try app.test(.POST, "new-pin") { req in
      try req.content.encode(credentialWithNewPIN)
    } afterResponse: { res in
      XCTAssertEqual(res.status, .ok, "Operation unsuccessful.")
      XCTAssertEqual(try res.content.decode(Credential.self), newCredential, "Credentials don't match.")
    }
    
    try app.test(.PUT, "authenticate") { req in
      try req.content.encode(newCredential)
    }
  }
}

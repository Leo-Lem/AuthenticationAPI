import class AuthenticatorAPI.Authenticator
import Vapor

extension Credential: Content {}
extension Credential.WithNewPIN: Content {}

public func configure(_ app: Application, authenticator: Authenticator) throws {
  app.post("register") { req in
    let credential = try req.content.decode(Credential.self)
    try authenticator.register(credential)
    return try await credential.encodeResponse(for: req)
  }
  
  app.post("deregister") { req in
    let credential = try req.content.decode(Credential.self)
    try authenticator.deregister(credential)
    return try await credential.encodeResponse(for: req)
  }
  
  app.post("new-pin") { req in
    let credentialWithNewPIN = try req.content.decode(Credential.WithNewPIN.self)
    try authenticator.changePIN(
      credentialWithNewPIN.credential,
      newPIN: credentialWithNewPIN.newPIN
    )
    return try await Credential(
      id: credentialWithNewPIN.credential.id,
      pin: credentialWithNewPIN.newPIN
    ).encodeResponse(for: req)
  }
  
  app.put("authenticate") { req in
    let credential = try req.content.decode(Credential.self)
    try authenticator.authenticate(credential)
    return try await credential.encodeResponse(for: req)
  }
}

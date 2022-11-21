import class AuthenticatorAPI.Authenticator
import Vapor

extension Credential: Content {}
extension Credential.WithNewPIN: Content {}

public enum PostRoute: String, CaseIterable {
  case register,
       authenticate,
       changePIN = "pin-change"
}

public extension PostRoute {
  func handleRequest(_ req: Request, authenticator: Authenticator) async throws -> Response {
    switch self {
    case .register:
      let credential = try req.content.decode(Credential.self)
      try authenticator.register(credential)
      return try await credential.encodeResponse(for: req)

    case .authenticate:
      let credential = try req.content.decode(Credential.self)
      try authenticator.authenticate(credential)
      return try await credential.encodeResponse(for: req)

    case .changePIN:
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
  }
}

import class AuthenticatorAPI.Authenticator
import Vapor

extension Credential: Content {}
extension Credential.WithNewPIN: Content {}

public func configure(_ app: Application, authenticator: Authenticator) throws {
  app.post("register") { req in
    let credential = try req.content.decode(Credential.self)

    do {
      try authenticator.register(credential)
    } catch let error as Authenticator.RegistrationError {
      throw Abort(.init(statusCode: error.rawValue))
    }

    return try await credential.encodeResponse(for: req)
  }

  app.post("deregister") { req in
    let credential = try req.content.decode(Credential.self)

    do {
      try authenticator.deregister(credential)
    } catch let error as Authenticator.RegistrationError {
      throw Abort(.init(statusCode: error.rawValue))
    }

    return try await credential.encodeResponse(for: req)
  }

  app.post("new-pin") { req in
    let credentialWithNewPIN = try req.content.decode(Credential.WithNewPIN.self)

    do {
      try authenticator.changePIN(
        credentialWithNewPIN.credential,
        newPIN: credentialWithNewPIN.newPIN
      )
    } catch let error as Authenticator.RegistrationError {
      throw Abort(.init(statusCode: error.rawValue))
    }

    return try await Credential(
      id: credentialWithNewPIN.credential.id,
      pin: credentialWithNewPIN.newPIN
    ).encodeResponse(for: req)
  }

  app.put("authenticate") { req in
    let credential = try req.content.decode(Credential.self)

    do {
      try authenticator.authenticate(credential)
    } catch let error as Authenticator.RegistrationError {
      throw Abort(.init(statusCode: error.rawValue))
    }

    return try await credential.encodeResponse(for: req)
  }

  #if DEBUG
    app.delete { _ in
      authenticator.clear()
      return "All user data cleared successfully!"
    }
  #endif
}

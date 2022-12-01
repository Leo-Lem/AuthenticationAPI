import Vapor

extension Credential: Content {}
extension Credential.WithNewPIN: Content {}

@main
struct App {
  static func main() throws {
    var env = try Environment.detect()
    try LoggingSystem.bootstrap(from: &env)
    
    let app = Application(env)
    let authenticator = Authenticator()
    
    defer { app.shutdown() }
    try app.configure(authenticator: authenticator)
    try app.run()
  }
}

extension Application {
  func configure(authenticator: Authenticator) throws {
    put("exists") { req in
      let id = try req.content.decode(Credential.ID.self)

      if authenticator.exists(with: id) {
        return "Success!"
      } else {
        throw Abort(.notFound)
      }
    }
    
    post("register") { req in
      do {
        let credential = try req.content.decode(Credential.self)

        try authenticator.register(credential)
        
        return try await credential.encodeResponse(for: req)
      } catch let error as Authenticator.RegistrationError {
        throw Abort(.init(statusCode: error.rawValue))
      }
    }

    put("login") { req in
      do {
        let credential = try req.content.decode(Credential.self)
        
        try authenticator.login(credential)
        
        return try await credential.encodeResponse(for: req)
      } catch let error as Authenticator.AuthenticationError {
        throw Abort(.init(statusCode: error.rawValue))
      }
    }
    
    post("new-pin") { req in
      do {
        let credentialWithNewPIN = try req.content.decode(Credential.WithNewPIN.self)
        
        let newCredential = try authenticator.changePIN(credentialWithNewPIN)
        
        return try await newCredential.encodeResponse(for: req)
      } catch let error as Authenticator.AuthenticationError {
        throw Abort(.init(statusCode: error.rawValue))
      }
    }

    delete("deregister") { req in
      do {
        let credential = try req.content.decode(Credential.self)

        try authenticator.deregister(credential)
        
        return try await credential.encodeResponse(for: req)
      } catch let error as Authenticator.AuthenticationError {
        throw Abort(.init(statusCode: error.rawValue))
      }
    }

    #if DEBUG
      delete { _ in
        authenticator.reset()
        return "All user data cleared successfully!"
      }
    #endif
  }
}

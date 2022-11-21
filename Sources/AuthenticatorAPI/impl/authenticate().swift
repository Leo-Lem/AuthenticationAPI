//	Created by Leopold Lemmermann on 21.11.22.

public extension Authenticator {
  func authenticate(_ credential: Credential) throws {
    guard credentials[credential.id] != nil else {
      throw AuthenticationError.unknownID
    }

    guard credentials[credential.id] == credential.pin else {
      throw AuthenticationError.wrongPIN
    }
  }
}

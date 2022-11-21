//	Created by Leopold Lemmermann on 21.11.22.

public extension Authenticator {
  func changePIN(_ credential: Credential, newPIN: String) throws {
    try authenticate(credential)

    credentials[credential.id] = newPIN
  }
}

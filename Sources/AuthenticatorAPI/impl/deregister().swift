//	Created by Leopold Lemmermann on 21.11.22.

public extension Authenticator {
  func deregister(_ credential: Credential) throws {
    try authenticate(credential)
    
    credentials.removeValue(forKey: credential.id)
  }
}


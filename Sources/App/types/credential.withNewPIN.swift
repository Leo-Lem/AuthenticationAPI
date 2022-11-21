//	Created by Leopold Lemmermann on 21.11.22.

public extension Credential {
  struct WithNewPIN: Codable, Hashable {
    public let credential: Credential,
               newPIN: String
    
    public init(credential: Credential, newPIN: String) {
      self.credential = credential
      self.newPIN = newPIN
    }
  }
}

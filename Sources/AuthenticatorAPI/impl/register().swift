//	Created by Leopold Lemmermann on 21.11.22.

public extension Authenticator {
  func register(_ credential: Credential) throws {
    guard
      credential.id.rangeOfCharacter(
        from: .alphanumerics.union(.punctuationCharacters).inverted
      ) == nil,
      !credential.id.isEmpty
    else {
      throw RegistrationError.invalidID
    }
    
    guard credentials[credential.id] == nil else {
      throw RegistrationError.idTaken
    }
    
    credentials[credential.id] = credential.pin
  }
}

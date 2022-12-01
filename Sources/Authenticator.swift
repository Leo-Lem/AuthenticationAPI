//  Created by Leopold Lemmermann on 20.11.22.

import struct LeosMisc.Persisted

class Authenticator {
  @Persisted("Credentials") var credentials = [Credential.ID: Credential.PIN]()
  
  func exists(with id: Credential.ID) -> Bool { credentials[id] != nil }
  
  func login(_ credential: Credential) throws {
    guard credentials[credential.id] != nil else { throw AuthenticationError.unknownID }
    guard credentials[credential.id] == credential.pin else { throw AuthenticationError.wrongPIN }
  }
  
  func register(_ credential: Credential) throws {
    guard
      credential.id.rangeOfCharacter(
        from: .alphanumerics.union(.punctuationCharacters).inverted
      ) == nil,
      !credential.id.isEmpty
    else {
      throw RegistrationError.invalidID
    }
    
    guard credentials[credential.id] == nil else { throw RegistrationError.idTaken }
    
    credentials[credential.id] = credential.pin
  }
  
  func changePIN(_ credentialWithNewPIN: Credential.WithNewPIN) throws -> Credential {
    try login(credentialWithNewPIN.credential)

    credentials[credentialWithNewPIN.credential.id] = credentialWithNewPIN.newPIN
    
    return Credential(id: credentialWithNewPIN.credential.id, pin: credentialWithNewPIN.newPIN)
  }
  
  func deregister(_ credential: Credential) throws {
    try login(credential)
    
    credentials.removeValue(forKey: credential.id)
  }
  
  #if DEBUG
  func reset() { credentials = [:] }
  #endif
}

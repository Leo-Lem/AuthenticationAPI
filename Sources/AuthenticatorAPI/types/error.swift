//	Created by Leopold Lemmermann on 20.11.22.

public extension Authenticator {
  enum RegistrationError: Error {
    case idTaken,
         invalidID,
         invalidPIN
  }

  enum AuthenticationError: Error {
    case unknownID,
         wrongPIN
  }

  enum ModificationError: Error {
    case newPINInvalid
  }
}

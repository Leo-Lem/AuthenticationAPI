//	Created by Leopold Lemmermann on 20.11.22.

// the raw value corresponds to an encoding in http status codes
extension Authenticator {
  enum RegistrationError: Int, Error {
    case idTaken = 409, invalidID = 400
  }

  enum AuthenticationError: Int, Error {
    case unknownID = 404, wrongPIN = 401
  }
}

//	Created by Leopold Lemmermann on 20.11.22.

public struct Credential: Codable, Hashable {
  public let id: String,
             pin: String
  
  public init(id: String, pin: String) {
    self.id = id
    self.pin = pin
  }
}

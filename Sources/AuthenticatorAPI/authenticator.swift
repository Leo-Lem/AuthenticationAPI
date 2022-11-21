//	Created by Leopold Lemmermann on 20.11.22.

public class Authenticator {
  @Persisted("Credentials") var credentials = [String: String]()

  public init() {}
  
  #if DEBUG
  public func clear() {
    credentials = [:]
  }
  #endif
}

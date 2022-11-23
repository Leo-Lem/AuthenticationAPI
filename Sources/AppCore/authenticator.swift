//  Created by Leopold Lemmermann on 20.11.22.

public class Authenticator {
  @Persisted("Credentials") var credentials = [String: String]()

  public init() {}
  
  #if DEBUG
  public func clear() {
    credentials = [:]
  }
  #endif
}

// persisted property wrapper

import Foundation

@propertyWrapper
struct Persisted<T: Codable> {
  var wrappedValue: T {
    didSet {
      do {
        try JSONEncoder()
          .encode(wrappedValue)
          .write(to: url)
      } catch {
        #if DEBUG
          print(error.localizedDescription)
        #endif
      }
    }
  }

  private let url: URL
  
  init(wrappedValue: T, _ key: String) {
    do {
      url = Bundle.main.bundleURL.appendingPathComponent("\(key).json")

      self.wrappedValue = try JSONDecoder()
        .decode(
          T.self,
          from: try Data(contentsOf: url)
        )
    } catch {
      #if DEBUG
        print(error.localizedDescription)
      #endif
      self.wrappedValue = wrappedValue
    }
  }
}

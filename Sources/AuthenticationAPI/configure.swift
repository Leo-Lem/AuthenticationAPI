import class AuthenticatorAPI.Authenticator
import Vapor

public func configure(_ app: Application, authenticator: Authenticator) throws {
  for postRoute in PostRoute.allCases {
    app.post(.constant(postRoute.rawValue)) { req in
      try await postRoute.handleRequest(req, authenticator: authenticator)
    }
  }
}

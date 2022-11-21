import AuthenticatorAPI
import AuthenticationAPI
import Vapor

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)

let app = Application(env)
let authenticator = Authenticator()

defer { app.shutdown() }
try configure(app, authenticator: authenticator)
try app.run()

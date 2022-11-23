import App
import AppCore
import Vapor

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)

let app = Application(env)
let authenticator = AppCore.Authenticator()

defer { app.shutdown() }
try configure(app, authenticator: authenticator)
try app.run()

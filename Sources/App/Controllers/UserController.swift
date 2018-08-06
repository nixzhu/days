import Vapor
import Crypto

final class UserController: RouteCollection {

    func boot(router:  Router) throws {
        let users = router.grouped("users")
        users.post("/", use: register)
        let middleware = User.basicAuthMiddleware(using: BCryptDigest())
        let authed = users.grouped(middleware)
        authed.post("login", use: login)
    }

    func register(_ req: Request) throws -> Future<User.Public> {
        return try req.content.decode(User.self).flatMap { user in
            let hasher = try req.make(BCryptDigest.self)
            let hashedPassword = try hasher.hash(user.password)
            let newUser = User(
                email: user.email,
                password: hashedPassword
            )
            return newUser.save(on: req).map { storedUser in
                return User.Public(
                    id: try storedUser.requireID(),
                    email: storedUser.email
                )
            }
        }
    }

    func login(_ req: Request) throws -> User.Public {
        let user = try req.requireAuthenticated(User.self)
        return User.Public(
            id: try user.requireID(),
            email: user.email
        )
    }
}

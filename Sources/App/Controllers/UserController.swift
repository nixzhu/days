import Vapor
import Crypto
import FluentSQL

final class UserController: RouteCollection {

    func boot(router: Router) throws {
        let users = router.grouped("users")
        users.post("/", use: register)
        let middleware = User.basicAuthMiddleware(using: BCryptDigest())
        let authed = users.grouped(middleware)
        authed.post("login", use: login)
    }

    func register(_ req: Request) throws -> Future<User.Public> {
        return try req.content.decode(User.self).flatMap { user in
            return User.query(on: req).filter(\User.email == user.email).first().flatMap { existingUser in
                guard existingUser == nil else {
                    throw Abort(.badRequest, reason: "用户已存在")
                }
                let newUser = User(
                    email: user.email,
                    password: try BCryptDigest().hash(user.password)
                )
                return newUser.save(on: req).map { storedUser in
                    return User.Public(
                        id: try storedUser.requireID(),
                        email: storedUser.email
                    )
                }
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

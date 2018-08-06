import Vapor

final class UserController: RouteCollection {

    func boot(router:  Router) throws {
        let users = router.grouped("users")
        users.post("/", use: create)
    }

    func create(_ req: Request) throws -> Future<User> {
        return try req.content.decode(User.self).flatMap { user in
            return user.save(on: req)
        }
    }
}

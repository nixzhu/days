import Vapor
import Crypto

final class PostController: RouteCollection {

    func boot(router: Router) throws {
        let posts = router.grouped("posts")
        posts.get("/", use: index)
        let middleware = User.basicAuthMiddleware(using: BCryptDigest())
        let authed = posts.grouped(middleware)
        authed.post("/", use: create)
    }

    func index(_ req: Request) throws -> Future<[Post]> {
        return Post.query(on: req).all()
    }

    func create(_ req: Request) throws -> Future<Post> {
        let user = try req.requireAuthenticated(User.self)
        let post = Post(
            markdown: "Hello",
            creatorID: try user.requireID()
        )
        let tag = Tag(name: "Tag1")
        _ = post.tags.attach(tag, on: req)
        return post.save(on: req)
    }
}

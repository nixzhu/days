import Vapor

final class PostController: RouteCollection {

    func boot(router:  Router) throws {
        let posts = router.grouped("posts")
        posts.get("/", use: index)
        posts.post("/", use: create)
    }

    func index(_ req: Request) throws -> Future<[Post]> {
        return Post.query(on: req).all()
    }

    func create(_ req: Request) throws -> Future<Post> {
        let user = User.query(on: req).first()
        return user.flatMap(to: Post.self) { user in
            guard let userID = user?.id else {
                throw Abort(.forbidden)
            }
            let post = Post(
                markdown: "Hello",
                creatorID: userID
            )
            let tag = Tag(name: "Tag1")
            _ = post.tags.attach(tag, on: req)
            return post.save(on: req)
        }
    }
}

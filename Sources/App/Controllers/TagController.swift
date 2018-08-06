import Vapor

final class TagController: RouteCollection {

    func boot(router: Router) throws {
        let tags = router.grouped("tags")
        tags.get("/", use: index)
    }

    func index(_ req: Request) throws -> Future<[Tag]> {
        return Tag.query(on: req).all()
    }
}

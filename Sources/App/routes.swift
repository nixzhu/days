import Vapor

public func routes(_ router: Router) throws {

    router.get("/") { req -> Future<View> in
        return try req.view().render("home")
    }

    router.get("about") { req -> Future<View> in
        return try req.view().render("about")
    }

    router.get("init") { req -> String in
        let todo = Todo(title: "阅读《编译器设计》", isChecked: false)
        _ = todo.create(on: req)
        return "OK"
    }

    try router.register(collection: AccountController())

    let api = router.grouped("api")
    try api.register(collection: TodoController())
    try api.register(collection: UserController())
    try api.register(collection: PostController())
    try api.register(collection: TagController())
}

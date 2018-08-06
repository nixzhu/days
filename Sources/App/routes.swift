import Vapor

public func routes(_ router: Router) throws {

    router.get("init") { req -> String in
        let todo = Todo(title: "阅读《编译器设计》", isChecked: false)
        _ = todo.create(on: req)
        return "OK"
    }

    try router.register(collection: TodoController())
    try router.register(collection: UserController())
    try router.register(collection: PostController())
    try router.register(collection: TagController())
}

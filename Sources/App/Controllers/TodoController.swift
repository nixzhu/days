import Vapor

final class TodoController: RouteCollection {

    func boot(router:  Router) throws {
        let todos = router.grouped("todos")
        todos.get("/", use: page)
        todos.get("/", Todo.parameter, use: read)
        todos.post("/", use: create)
        todos.patch("/", Todo.parameter, use: update)
        todos.delete("/", Todo.parameter, use: delete)
    }

    func page(_ req: Request) throws -> Future<TodoPage> {
        let page = (try? req.query.get(Int.self, at: "page")) ?? 1
        let perPage = (try? req.query.get(Int.self, at: "perPage")) ?? 5
        guard page > 0, perPage > 0 else {
            let headers: HTTPHeaders = ["error_code": "invalid_paging"]
            throw Abort(.badRequest, headers: headers, reason: "错误的分页参数")
        }
        let start = (page - 1) * perPage
        let end = page * perPage
        return Todo.query(on: req).range(start..<end).all().map { todos in
            return TodoPage(todos: todos, hasMore: todos.count == perPage)
        }
    }

    func read(_ req: Request) throws -> Future<Todo> {
        return try req.parameters.next(Todo.self)
    }

    func create(_ req: Request) throws -> Future<Todo> {
        return try req.content.decode(Todo.self).flatMap { todo in
            return todo.save(on: req)
        }
    }

    func update(_ req: Request) throws -> Future<Todo> {
        return try req.parameters.next(Todo.self).flatMap { todo in
            return try req.content.decode(Todo.self).flatMap { newTodo in
                todo.title = newTodo.title
                todo.isChecked = newTodo.isChecked
                return todo.save(on: req)
            }
        }
    }

    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Todo.self).flatMap { todo in
            return todo.delete(on: req)
        }.transform(to: .ok)
    }
}

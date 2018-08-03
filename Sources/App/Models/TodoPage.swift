import Foundation
import Vapor

struct TodoPage: Codable {
    let todos: [Todo]
    let hasMore: Bool
    init(todos: [Todo], hasMore: Bool) {
        self.todos = todos
        self.hasMore = hasMore
    }
}

extension TodoPage: Content { }

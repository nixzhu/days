import FluentSQLite
import Vapor

final class User: SQLiteModel {
    var id: Int?
    var username: String
}

extension User {
    var posts: Children<User, Post> {
        return children(\.creatorID)
    }
}

extension User: Migration { }
extension User: Content { }
extension User: Parameter { }

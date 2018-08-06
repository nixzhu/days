import FluentSQLite
import Vapor
import Authentication

final class User: SQLiteModel {
    var id: Int?
    var email: String
    var password: String

    init(id: Int? = nil, email: String, password: String) {
        self.email = email
        self.password = password
    }
}

extension User {
    var posts: Children<User, Post> {
        return children(\.creatorID)
    }
}

extension User: BasicAuthenticatable {
    static var usernameKey: WritableKeyPath<User, String> {
        return \.email
    }
    static var passwordKey: WritableKeyPath<User, String> {
        return \.password
    }
}

extension User {
    struct Public: Content {
        let id: Int
        let email: String
    }
}

extension User: Migration { }
extension User: Content { }
extension User: Parameter { }

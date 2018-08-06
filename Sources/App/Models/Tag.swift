import FluentSQLite
import Vapor

final class Tag: SQLiteModel {
    var id: Int?
    var name: String

    init(id: Int? = nil, name: String) {
        self.id = id
        self.name = name
    }
}

extension Tag {
    var posts: Siblings<Tag, Post, PostTag> {
        return siblings()
    }
}

extension Tag: Migration { }
extension Tag: Content { }
extension Tag: Parameter { }

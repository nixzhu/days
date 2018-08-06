import FluentSQLite
import Vapor

final class Post: SQLiteModel {
    var id: Int?
    var markdown: String
    var createdAt: Date
    var updatedAt: Date
    var creatorID: User.ID

    init(id: Int? = nil, markdown: String, creatorID: User.ID) {
        self.id = id
        self.markdown = markdown
        let now = Date()
        self.createdAt = now
        self.updatedAt = now
        self.creatorID = creatorID
    }
}

extension Post {
    var creator: Parent<Post, User> {
        return parent(\.creatorID)
    }
}

extension Post {
    var tags: Siblings<Post, Tag, PostTag> {
        return siblings()
    }
}

extension Post: Migration { }
extension Post: Content { }
extension Post: Parameter { }

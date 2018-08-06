import FluentSQLite

struct PostTag: SQLitePivot {
    typealias Left = Post
    typealias Right = Tag

    static var leftIDKey: LeftIDKey = \.postID
    static var rightIDKey: RightIDKey = \.tagID

    var id: Int?
    var postID: Post.ID
    var tagID: Tag.ID
}

extension PostTag: ModifiablePivot {
    init(_ post: Post, _ tag: Tag) throws {
        postID = try post.requireID()
        tagID = try tag.requireID()
    }
}

extension PostTag: Migration { }

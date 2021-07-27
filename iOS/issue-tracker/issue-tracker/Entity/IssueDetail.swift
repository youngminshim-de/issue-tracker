import Foundation

struct IssueDetail {
    
    let issueID: Int
    let title: String
    let issueNumber: Int
    let isOpen: Bool
    let label: String
    let milestone: String
    let createdTime: String
    let writer: Writer
    let assignees: [Writer]
    let comments: [Comment]
    
}

struct Comment {
    
    let commentID: Int
    let writer: Writer
    let createdTime: String
    let content: String
    let file: String
    let emojis: [Emoji]
    
}

struct Writer {
    
    let id: Int
    let username: String
    let profileImage: String

}

struct Emoji {
    
    let id: Int
    let name: String
    
}

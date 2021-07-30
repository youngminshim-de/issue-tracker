import Foundation

struct IssueDetailResponseDTO: Decodable {
    
    let data: IssueDetailDTO
    let error: String?
    
    func toDomain() -> IssueDetail {
        return .init(issueID: data.id, title: data.title, issueNumber: data.issueNumber, isOpen: data.isOpen, label: data.labels.first?.title ?? "", milestone: data.milestone?.title ?? "", createdTime: data.createdTime, writer: data.writer.toDomain(), assignees: data.assignees.map { $0.toDomain() }, comments: data.comments.map { $0.toDomain() })
    }
    
}

struct IssueDetailDTO: Decodable {
    
    let id: Int
    let title: String
    let issueNumber: Int
    let createdTime: String
    let comments: [CommentDTO]
    let isOpen: Bool
    let writer: WriterDTO
    let assignees: [WriterDTO]
    let milestone: MilestoneDTO?
    let labels: [LabelDTO]
    
    enum CodingKeys: String, CodingKey {
        case id, title, comments
        case issueNumber = "issue_number"
        case createdTime = "created_time"
        case isOpen = "is_open"
        case writer, assignees, milestone, labels
    }
    
}

struct CommentDTO: Decodable {
    
    let id: Int
    let writer: WriterDTO
    let content: String?
    let createdTime: String
    let emojis: [EmojiDTO]
    let file: String?
    
    enum CodingKeys: String, CodingKey {
        case id, writer, content, emojis, file
        case createdTime = "created_time"
    }
    
    func toDomain() -> Comment {
        return .init(commentID: self.id, writer: self.writer.toDomain(), createdTime: self.createdTime, content: self.content ?? "", file: self.file ?? "", emojis: self.emojis.map { $0.toDomain() })
    }
    
}

struct EmojiDTO: Decodable {
    
    let id: Int
    let name: String
    
    func toDomain() -> Emoji {
        return .init(id: self.id, name: self.name)
    }
}

struct NewCommentDTO: Encodable {
    
    let content: String
    let file: String?
    
}

struct NewEmojiDTO: Encodable {
    
    let emojiId: Int
    
    enum CodingKeys: String, CodingKey {
        case emojiId = "emoji_id"
    }
    
}

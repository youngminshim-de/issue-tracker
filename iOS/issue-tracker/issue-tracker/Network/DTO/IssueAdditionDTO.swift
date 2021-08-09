import Foundation

struct IssueAdditionDTO: Encodable {
    
    let title: String
    let comment: String
    let file: String?
    let labelIds: [Int]
    let milestoneId: Int
    let assigneeIds: [Int]
    
    enum CodingKeys: String, CodingKey {
        case title, comment, file
        case labelIds = "label_ids"
        case milestoneId = "milestone_id"
        case assigneeIds = "assignee_ids"
    }
    
}

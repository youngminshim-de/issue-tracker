import Foundation

struct IssueIDsDTO: Encodable {
    
    let issueIds: [Int]
    
    enum CodingKeys: String, CodingKey {
        case issueIds = "issue_ids"
    }
    
}

struct IssueAdditionEditDTO: Encodable {
    
    let labelIds: [Int]?
    let milestoneId: Int?
    let assigneeIds: [Int]?

    enum CodingKeys: String, CodingKey {
        case labelIds = "label_ids"
        case milestoneId = "milestone_id"
        case assigneeIds = "assignee_ids"
    }
    
}

struct IssueTitleDTO: Encodable {
    
    let title: String?
    
}

// 이하는 필요 없음
// IssueAdditionEditDTO로 퉁 쳤기 때문.
struct LabelIDsDTO: Encodable {
    
    let labelIds: [Int]
    
    enum CodingKeys: String, CodingKey {
        case labelIds = "label_ids"
    }
    
}

struct MilestoneIDDTO: Encodable {
    
    let milestoneId: Int
    
    enum CodingKeys: String, CodingKey {
        case milestoneId = "milestone_id"
    }
    
}

struct AssigneeIDsDTO: Encodable {
    
    let assigneeIds: [Int]
    
    enum CodingKeys: String, CodingKey {
        case assigneeIds = "assignee_ids"
    }
    
}

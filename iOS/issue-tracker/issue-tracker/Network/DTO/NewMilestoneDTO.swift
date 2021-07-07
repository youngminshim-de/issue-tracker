import Foundation

struct NewMilestoneDTO: Encodable {
    
    let title: String
    let content: String?
    let dueDate: String?
    
    enum CodingKeys: String, CodingKey {
        case title, content
        case dueDate = "due_date"
    }
    
}

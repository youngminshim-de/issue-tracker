import Foundation

struct FilterCondition {
    
    var isOpen: Bool?
    var filter: String?
    var assignee: Int?
    var label: Int?
    var milestone: Int?
    var writer: Int?
    
    func isOpenToString() -> String {
        guard let isOpen = isOpen else { return "" }
        return "\(isOpen)"
    }
    
    func filterToString() -> String {
        guard let filter = filter else { return "" }
        return filter
    }
    
    func assigneeToString() -> String {
        guard let assignee = assignee else { return "" }
        return "\(assignee)"
    }
    
    func labelToString() -> String {
        guard let label = label else { return "" }
        return "\(label)"
    }
    
    func milestoneToString() -> String {
        guard let milestone = milestone else { return "" }
        return "\(milestone)"
    }
    
    func writerToString() -> String {
        guard let writer = writer else { return "" }
        return "\(writer)"
    }
    
}

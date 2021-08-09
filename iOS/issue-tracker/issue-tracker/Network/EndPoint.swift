import Foundation

enum Scheme: String {
    
    case http = "http"
    
}

enum Host: String {
    
    case base = "www.sionn.net"
    
}

enum Path: String {
    
    case api = "/api"
    case login = "/login"
    case user = "/user"
    case users = "/users"
    case issues = "/issues"
    case open = "/open"
    case close = "/close"
    case label = "/labels"
    case title = "/title"
    case milestone = "/milestone"
    case milestones = "/milestones"
    case assignees = "/assignees"
    case comments = "/comments"
    case emojis = "/emojis"
    
}

enum FilterState: String {
    
    case myIssue = "my_issue"
    case myComment = "my_comment"
    case myAssign = "my_assign"
    
}

enum SocialLogin: String {
    
    case google = "/google/ios"
    case kakao = "/kakao/ios"
    case naver = "/naver/ios"
    
}

struct EndPoint {

    private var scheme: String
    private var host: String
    private var path: String
    
    init(scheme: String, host: String, path: String) {
        self.scheme = scheme
        self.host = host
        self.path = path
    }
    
    func makeURL(with path: String = "") -> URL? {
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.path = self.path + path
        return component.url
    }
    
    func makeFilterURL(filterCondition: FilterCondition) -> URL? {
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.path = self.path
        
        let isOpen = URLQueryItem(name: "is_open", value: filterCondition.isOpenToString())
        let state = URLQueryItem(name: "filter", value: filterCondition.filterToString())
        let assignee = URLQueryItem(name: "assignee", value: filterCondition.assigneeToString())
        let label = URLQueryItem(name: "label", value: filterCondition.labelToString())
        let milestone = URLQueryItem(name: "milestone", value: filterCondition.milestoneToString())
        let writer = URLQueryItem(name: "writer", value: filterCondition.writerToString())
        
        component.queryItems = [isOpen, state, assignee, label, milestone, writer]
        return component.url
    }
    
}

//
//  IssueDetail.swift
//  Issue-Trackker
//
//  Created by 심영민 on 2021/06/14.
//

import Foundation

struct IssueDetail: Decodable {
    var id: Int
    var title: String
    var writer: String
    var writeTime: String
    var milestone: Milestone?
    var assignments: [Assignment]?
    var labels: [Label]?
    var text: String
    var status: String
    var writerAvatarImage: String
    var comments: [Comment]
    
    static var empty = Self.init()
    
    init() {
        self.id = 0
        self.title = ""
        self.writer = ""
        self.writeTime = ""
        self.milestone = Milestone.empty
        self.assignments = []
        self.labels = []
        self.text = ""
        self.status = ""
        self.writerAvatarImage = ""
        self.comments = []
    }
    
    var statusDescription: String {
        return status == "OPEN" ? "열림" : "닫힘"
    }
    
    var idDescription: String {
        return "#\(id)"
    }
    
    var writeTimeDescription: String {
        return DateFormatter.calculateTimeDifference(date: writeTime) + ", \(writer)님이 작성했습니다."
    }
}

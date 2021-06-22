//
//  Milestone.swift
//  Issue-Trackker
//
//  Created by 심영민 on 2021/06/13.
//

import Foundation

struct Milestone: Decodable {
    var id: Int
    var title: String
    var detail: String
    var deadLine: String
    var complete: Int?
    var openIssueCount: Int?
    var closeIssueCount: Int?
    
    static var empty = Self.init()
    
    init() {
        self.id = 0
        self.title = ""
        self.detail = ""
        self.deadLine = ""
        self.complete = nil
        self.openIssueCount = nil
        self.closeIssueCount = nil
    }
}

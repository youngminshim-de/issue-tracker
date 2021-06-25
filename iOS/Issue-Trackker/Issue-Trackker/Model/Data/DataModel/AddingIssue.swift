//
//  AddingIssue.swift
//  Issue-Trackker
//
//  Created by 심영민 on 2021/06/24.
//

import Foundation

struct AddingIssue: Codable {
    var title: String
    var text: String
    var assignments: [String]?
    var labels: [Int]?
    var milestone: Int?
    
    static var empty = Self()
    
    init() {
        self.title = ""
        self.text = ""
        self.assignments  = []
        self.labels = []
        self.milestone = nil
    }
}

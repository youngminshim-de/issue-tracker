//
//  Label.swift
//  Issue-Trackker
//
//  Created by 심영민 on 2021/06/13.
//

import Foundation

struct Label: Decodable {
    var id: Int
    var title: String
    var detail: String
    var hexCode: String
}

//
//  DateFormatter.swift
//  Issue-Trackker
//
//  Created by 심영민 on 2021/06/22.
//

import Foundation

extension DateFormatter  {
    static func calculateTimeDifference(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko")
        
        guard let writeTime = dateFormatter.date(from: date) else {
            return ""
        }
        let timeDifference = -writeTime.timeIntervalSinceNow
        return convertTime(sec: timeDifference)
    }
    
    private static func convertTime(sec: TimeInterval) -> String {
        let minute = Int(sec) / Hour.minute.rawValue
        if minute >= Hour.day.rawValue {
            return "\(minute / Hour.day.rawValue)일 전"
        } else {
            return "\(minute)분 전"
        }
    }
}

enum Hour: Int {
    case minute = 60
    case day = 1440
}

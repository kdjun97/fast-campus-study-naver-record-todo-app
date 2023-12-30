//
 //  Todo.swift
 //  RecordingTodoApp
 //
 //  Created by 김동준 on 12/30/23
 //

import Foundation

struct Todo: Hashable {
    var title: String
    var time: Date
    var day: Date
    var selected: Bool
    
    var convertedDayAndTime: String {
        return "\(day.formattedDay) - \(time.formattedTime)에 알림"
    }
}

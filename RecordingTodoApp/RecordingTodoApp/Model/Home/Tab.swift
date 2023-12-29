//
 //  Tab.swift
 //  RecordingTodoApp
 //
 //  Created by 김동준 on 12/29/23
 //

import Foundation

enum Tab {
    case todoList
    case memo
    case voiceRecorder
    case timer
    case setting
}

extension Tab {
    func getImageName(isActive: Bool) -> String {
        switch (self) {
        case .todoList:
            return isActive ? "todo_tab_active" : "todo_tab"
        case .memo:
            return isActive ? "memo_tab_active" : "memo_tab"
        case .voiceRecorder:
            return isActive ? "record_tab_active" : "record_tab"
        case .timer:
            return isActive ? "timer_tab_active" : "timer_tab"
        case .setting:
            return isActive ? "setting_tab_active" : "setting_tab"
        }
    }
}

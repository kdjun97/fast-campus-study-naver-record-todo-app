//
 //  TodoViewModel.swift
 //  RecordingTodoApp
 //
 //  Created by 김동준 on 12/30/23
 //

import Foundation

class TodoViewModel: ObservableObject {
    @Published var title: String
    @Published var time: Date
    @Published var day: Date
    @Published var isShowCalendar: Bool
    
    init(
        title: String = "",
        time: Date = Date(),
        day: Date = Date(),
        isShowCalendar: Bool = false
    ) {
        self.title = title
        self.time = time
        self.day = day
        self.isShowCalendar = isShowCalendar
    }
}

extension TodoViewModel {
    func showIsShowCalendar(isShow: Bool) {
        isShowCalendar = isShow
    }
}

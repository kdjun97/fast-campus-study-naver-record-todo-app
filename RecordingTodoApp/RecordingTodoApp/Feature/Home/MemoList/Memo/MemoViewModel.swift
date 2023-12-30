//
 //  MemoViewModel.swift
 //  RecordingTodoApp
 //
 //  Created by 김동준 on 12/30/23
 //

import Foundation

class MemoViewModel: ObservableObject {
    @Published var memo: Memo
    
    init(memo: Memo = .init(title: "", content: "", date: Date())) {
        self.memo = memo
    }
}

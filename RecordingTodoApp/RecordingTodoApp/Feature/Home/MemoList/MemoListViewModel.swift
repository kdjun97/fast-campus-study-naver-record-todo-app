//
 //  MemoListViewModel.swift
 //  RecordingTodoApp
 //
 //  Created by 김동준 on 12/30/23
 //

import Foundation

class MemoListViewModel: ObservableObject {
    @Published var memoList: [Memo] = []
    @Published var removeMemoList: [Memo] = []
    @Published var isEditable: Bool
    @Published var isPresentedDialog: Bool
    
    init(
        memoList: [Memo] = [],
        removeMemoList: [Memo] = [],
        isEditable: Bool = false,
        isPresentedDialog: Bool = false
    ) {
        self.memoList = memoList
        self.removeMemoList = removeMemoList
        self.isEditable = isEditable
        self.isPresentedDialog = isPresentedDialog
    }
    
    var memoType: CustomNavigationBarType {
        return isEditable
        ? .complete
        : .create
    }
        
    func removeMemoTapped(memo: Memo) {
        if let index = removeMemoList.firstIndex(of: memo) {
            removeMemoList.remove(at: index)
        } else {
            removeMemoList.append(memo)
        }
    }
    
    func setIsPresentedDialog(isShow: Bool) {
        isPresentedDialog = isShow
    }
    
    func removeButtonTapped() {
        memoList.removeAll { memo in
            removeMemoList.contains(memo)
        }
        removeMemoList.removeAll()
    }
    
    func addMemo(memo: Memo) {
        memoList.append(memo)
    }
    
    func updateMemo(memo: Memo) {
        if let index = memoList.firstIndex(where: { $0.id == memo.id }) {
            memoList[index] = memo
        }
    }
}

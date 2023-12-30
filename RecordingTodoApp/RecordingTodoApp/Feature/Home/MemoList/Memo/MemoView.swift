//
 //  MemoView.swift
 //  RecordingTodoApp
 //
 //  Created by 김동준 on 12/29/23
 //

import Foundation
import SwiftUI

struct MemoView: View {
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    @EnvironmentObject private var pathModel: PathModel
    @StateObject var memoViewModel: MemoViewModel
    @State var isCreatedType: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(
                isShowBackButton: true,
                isShowTrailingButton: true,
                leadingButtonAction: {
                    pathModel.paths.removeLast()
                },
                trailingButtonAction: {
                    if (isCreatedType) {
                        memoListViewModel.addMemo(memo: memoViewModel.memo)
                    } else {
                        memoListViewModel.updateMemo(memo: memoViewModel.memo)
                    }
                    pathModel.paths.removeLast()
                },
                type: isCreatedType ? .create : .edit
            )
            TitleTextField(memoViewModel: memoViewModel, isCreatedType: $isCreatedType).padding(.top, 20)
            ContentTextField(memoViewModel: memoViewModel).padding(.top, 48)
            Spacer()
        }
    }
}

private struct TitleTextField: View {
    @ObservedObject private var memoViewModel: MemoViewModel
    @FocusState private var isTitleFieldFocused: Bool
    @Binding private var isCreatedType: Bool
    
    fileprivate init(
        memoViewModel: MemoViewModel,
        isCreatedType: Binding<Bool>
    ) {
        self.memoViewModel = memoViewModel
        self._isCreatedType = isCreatedType
    }
    
    fileprivate var body: some View {
        HStack {
            TextField(
                "제목을 입력하세요",
                text: $memoViewModel.memo.title
            )
            .font(.system(size: 30, weight: .bold))
            .padding(.leading, 20)
            .focused($isTitleFieldFocused)
            .onAppear {
                if (isCreatedType) {
                    isTitleFieldFocused = true
                }
            }
        }
    }
}

private struct ContentTextField: View {
    @ObservedObject private var memoViewModel: MemoViewModel
    
    fileprivate init(memoViewModel: MemoViewModel) {
        self.memoViewModel = memoViewModel
    }
    
    fileprivate var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $memoViewModel.memo.content)
                .font(.system(size: 20))
            
            if memoViewModel.memo.content.isEmpty {
                Text("메모를 입력하세요.")
                    .font(.system(size: 16))
                    .foregroundColor(.customGray1)
                    .allowsHitTesting(false)
                    .padding(.top, 10)
                    .padding(.leading, 5)
            }
        }.padding(.horizontal, 20)
    }
}

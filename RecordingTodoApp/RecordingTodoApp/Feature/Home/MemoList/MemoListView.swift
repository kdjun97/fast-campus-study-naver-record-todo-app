//
 //  MemoListView.swift
 //  RecordingTodoApp
 //
 //  Created by 김동준 on 12/30/23
 //

import Foundation
import SwiftUI

struct MemoListView: View {
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    @EnvironmentObject private var pathModel: PathModel

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                if (!memoListViewModel.memoList.isEmpty) {
                    CustomNavigationBar(
                        isShowBackButton: false,
                        isShowTrailingButton: true,
                        trailingButtonAction: {
                            memoListViewModel.setIsPresentedDialog(isShow: true)
                        },
                        type: .complete
                    )
                }
                TitleView().padding(.top, 20)
                if (memoListViewModel.memoList.isEmpty) {
                    MemoPreview()
                } else {
                    MemoContentView()
                    .padding(.top, 24)
                    .padding(.bottom, 12)
                }
            }
            WirteMemoButtonView()
            .padding(.trailing, 20)
            .padding(.bottom, 50)
        }.alert(
            "메모 \(memoListViewModel.removeMemoList.count)개 삭제하시겠습니까?",
            isPresented: $memoListViewModel.isPresentedDialog
        ) {
            Button("취소", role: .cancel) {}
            Button("삭제", role: .destructive) {
                memoListViewModel.removeButtonTapped()
            }
        }
    }
}

private struct TitleView: View {
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    
    fileprivate var body: some View {
        HStack {
            if (memoListViewModel.memoList.isEmpty) {
                Text("메모를\n추가해보세요.")
                    .font(.system(size: 30, weight: .bold))
                    .padding(.leading, 20)
            } else {
                Text("메모 \(memoListViewModel.memoList.count)개가\n있습니다.")
                    .font(.system(size: 30, weight: .bold))
                    .padding(.leading, 20)
            }
            Spacer()
        }
    }
}

private struct MemoPreview: View {
    fileprivate var body: some View {
        VStack(spacing: 15) {
            Spacer()
            Image("pencil")
                .renderingMode(.template)
            Text("\"예시 메모\"")
            Text("\"오늘 세재 사야함\"")
            Text("\"내일 피아노 쳐야함!!\"")
            Spacer()
        }
        .font(.system(size: 16))
        .foregroundColor(.customGray2)
    }
}

private struct MemoContentView: View {
    @EnvironmentObject private var memoListViewModel: MemoListViewModel

    fileprivate var body: some View {
        VStack(spacing: 0) {
            HStack {
               Text("메모 목록")
                    .font(.system(size: 16, weight: .bold))
               Spacer()
            }.padding(.leading, 20)
                .padding(.bottom, 8)
            Rectangle()
                .fill(.customGray0)
                .frame(height: 1)
            ScrollView {
                ForEach(memoListViewModel.memoList, id: \.self) { memo in
                    MemoCellItem(memo: memo)
                    Rectangle()
                    .fill(.customGray0)
                    .frame(height: 1)
                }
            }
        }
    }
}

private struct MemoCellItem: View {
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    @EnvironmentObject private var pathModel: PathModel
    @State var isActive: Bool = false
    private var memo: Memo
    
    fileprivate init(memo: Memo) {
        self.memo = memo
    }
    
    fileprivate var body: some View {
        HStack {
            Button {
                pathModel.paths.append(.memoView(memo: memo, isCreatedType: false))
            } label : {
                VStack (alignment:.leading ,spacing: 2) {
                    Text(memo.title)
                        .font(.system(size: 16))
                        .foregroundColor(.customBK)
                    Text(memo.convertedDate)
                        .font(.system(size: 12))
                        .foregroundColor(.customIconOn)
                }
            }.padding(.vertical, 24)
            Spacer()
            Button {
                isActive.toggle()
                memoListViewModel.removeMemoTapped(memo: memo)
            } label: {
                isActive
                ? Image("selectedCheckBox")
                : Image("unSelectedCheckBox")
            }
        }.padding(.horizontal, 30)
    }
}

private struct WirteMemoButtonView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                Button{
                    pathModel.paths.append(.memoView(memo: nil, isCreatedType: true))
                } label: {
                    Image("writeButton")
                }
            }
        }
    }
}

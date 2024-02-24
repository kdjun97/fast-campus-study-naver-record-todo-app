//
 //  CustomNavigationBar.swift
 //  RecordingTodoApp
 //
 //  Created by 김동준 on 12/30/23
 //

import SwiftUI

struct CustomNavigationBar: View {
    let isShowBackButton: Bool
    let isShowTrailingButton: Bool
    let leadingButtonAction: (() -> Void)?
    let trailingButtonAction: (() -> Void)?
    let type: CustomNavigationBarType
    
    init(
        isShowBackButton: Bool = false,
        isShowTrailingButton: Bool = false,
        leadingButtonAction: (() -> Void)? = nil,
        trailingButtonAction: (() -> Void)? = nil,
        type: CustomNavigationBarType
    ) {
        self.isShowBackButton = isShowBackButton
        self.isShowTrailingButton = isShowTrailingButton
        self.leadingButtonAction = leadingButtonAction
        self.trailingButtonAction = trailingButtonAction
        self.type = type
    }
    
    var body: some View {
        HStack(spacing: 0) {
            if (isShowBackButton) {
                Button {
                    if let leadingButtonAction = leadingButtonAction {
                        leadingButtonAction()
                    }
                } label: {
                    Image("backButton")
                }.padding(.leading, 24)
            }
            Spacer()
            if (isShowTrailingButton) {
                Button {
                    if let trailingButtonAction = trailingButtonAction {
                        trailingButtonAction()
                    }
                } label: {
                    Text(type.rawValue)
                        .font(.system(size: 14))
                        .foregroundColor(.customBK)
                }.padding(.trailing, 32)
            }
        }
   }
}

enum CustomNavigationBarType: String {
    case edit = "편집"
    case complete = "완료"
    case create = "생성"
}

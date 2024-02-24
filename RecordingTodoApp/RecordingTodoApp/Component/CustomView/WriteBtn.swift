//
 //  WriteBtn.swift
 //  RecordingTodoApp
 //
 //  Created by 김동준 on 2/24/24
 //

import Foundation
import SwiftUI

// 1번 방법
public struct WriteBtnViewModifier: ViewModifier {
    let action: () -> Void
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button {
                        action()
                    } label: {
                        Image("writeButton")
                    }
                }
            }
            .padding(.trailing, 20)
            .padding(.bottom, 50)
        }
    }
}


// 2번 방법 : View Extension
extension View {
    public func writeBtn(perform action: @escaping () -> Void) -> some View {
        ZStack {
            self
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button {
                        action()
                    } label: {
                        Image("writeButton")
                    }
                }
            }
            .padding(.trailing, 20)
            .padding(.bottom, 50)
        }
    }
}

// 3번 방법 : 새로운 뷰
public struct WriteBtnView<Content: View>: View {
    let content: Content
    let action: ()-> Void
    
    public init(@ViewBuilder content: () -> Content, action: @escaping () -> Void) {
        self.content = content()
        self.action = action
    }
    
    public var body: some View {
        ZStack {
            content
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button {
                        action()
                    } label: {
                        Image("writeButton")
                    }
                }
            }
            .padding(.trailing, 20)
            .padding(.bottom, 50)
        }
    }
}

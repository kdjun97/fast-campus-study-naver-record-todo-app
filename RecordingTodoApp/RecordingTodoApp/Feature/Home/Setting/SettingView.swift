//
 //  SettingView.swift
 //  RecordingTodoApp
 //
 //  Created by 김동준 on 12/29/23
 //

import Foundation
import SwiftUI

struct SettingView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    var body: some View {
        VStack {
            TitleView()

            Spacer()
                .frame(height: 36)
            
            TotalTabCountView(homeViewModel: homeViewModel)
            
            Spacer()
                .frame(height: 36)
            
            TotalTabMoveView(homeViewModel: homeViewModel)
            
            Spacer()
        }
    }
}

private struct TitleView: View {
    fileprivate var body: some View {
        HStack {
            Text("설정")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.customBK)
            
            Spacer()
        }
        .padding(.top, 45)
        .padding(.horizontal, 30)
    }
}

private struct TotalTabCountView: View {
    @ObservedObject private var homeViewModel : HomeViewModel
    
    fileprivate init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
    }
    
    fileprivate var body: some View {
        HStack {
            Spacer()
            TabCountView(title: "To do", count: homeViewModel.todosCount)
            Spacer()
            TabCountView(title: "메모", count: homeViewModel.memosCount)
            Spacer()
            TabCountView(title: "음성메모", count: homeViewModel.voiceRecorderCount)
            Spacer()
        }
    }
}

private struct TabCountView: View {
    private var title: String
    private var count: Int
    
    fileprivate init(title: String, count: Int) {
        self.title = title
        self.count = count
    }
    
    fileprivate var body: some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.customBK)
            Text("\(count)")
                .font(.system(size: 30, weight: .medium))
                .foregroundColor(.customBK)
        }
    }
}

private struct TotalTabMoveView: View {
    @ObservedObject private var homeViewModel : HomeViewModel
    
    fileprivate init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            Rectangle()
                .fill(.customGray1)
                .frame(height: 1)
            
            TabMoveView(title: "To do List", tabAction: {
                homeViewModel.selectedTab = .todoList
            })
            
            TabMoveView(title: "메모장", tabAction: {
                homeViewModel.selectedTab = .memo
            })
            
            TabMoveView(title: "음성메모", tabAction: {
                homeViewModel.selectedTab = .voiceRecorder
            })
            
            TabMoveView(title: "타이머", tabAction: {
                homeViewModel.selectedTab = .timer
            })
        }
    }
}

private struct TabMoveView: View {
    private var title: String
    private var tabAction: () -> Void
    
    fileprivate init(title: String, tabAction: @escaping () -> Void) {
        self.title = title
        self.tabAction = tabAction
    }
    
    fileprivate var body: some View {
        Button {
            tabAction()
        } label: {
            HStack {
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(.customBK)
                Spacer()
                Image("right-arrow")
            }
        }
        .padding(.all, 20)
    }
}

#Preview {
    SettingView()
}

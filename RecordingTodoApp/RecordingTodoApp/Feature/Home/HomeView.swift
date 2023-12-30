//
 //  HomeView.swift
 //  RecordingTodoApp
 //
 //  Created by 김동준 on 12/29/23
 //

import Foundation
import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var pathModel: PathModel
    @StateObject private var homeViewModel = HomeViewModel()
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $homeViewModel.selectedTab) {
                TodoListView()
                    .environmentObject(pathModel)
                    .environmentObject(todoListViewModel)
                    .tag(Tab.todoList)
                MemoView()
                    .tag(Tab.memo)
                VoiceRecorderView()
                    .tag(Tab.voiceRecorder)
                TimerView()
                    .tag(Tab.timer)
                SettingView()
                    .tag(Tab.setting)
            }
            CustomTabBar(homeViewModel: homeViewModel)
        }
    }
}

private struct CustomTabBar: View {
    @ObservedObject private var homeViewModel: HomeViewModel
    let tabBarItemList: [Tab] = [.todoList, .memo, .voiceRecorder, .timer, .setting]
    
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
    }
    
    fileprivate var body: some View {
        VStack(spacing: 0) {
            SeperatorLineView()
            HStack(spacing: 0) {
                Spacer()
                ForEach(tabBarItemList, id: \.self) { item in
                    Button{
                        homeViewModel.selectedTab = item
                    } label: {
                        getTabBarItem(currentTab: item)
                    }
                    Spacer()
                }
            }
        }
    }
    
    private func getTabBarItem(currentTab: Tab) -> Image {
        var imageName = ""
        if (homeViewModel.selectedTab == currentTab) {
            imageName = currentTab.getImageName(isActive: true)
        } else {
            imageName = currentTab.getImageName(isActive: false)
        }
        return Image(imageName)
    }
}

private struct SeperatorLineView: View {
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [.customWH, .gray.opacity(0.1)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            ).frame(height: 10)
    }
}

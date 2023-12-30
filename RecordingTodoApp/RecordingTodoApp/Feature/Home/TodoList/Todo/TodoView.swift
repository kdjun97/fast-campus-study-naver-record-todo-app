//
 //  TodoView.swift
 //  RecordingTodoApp
 //
 //  Created by 김동준 on 12/29/23
 //

import Foundation
import SwiftUI

struct TodoView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @StateObject private var todoViewModel = TodoViewModel()

    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(
                isShowBackButton: true,
                isShowTrailingButton: true,
                leadingButtonAction: {
                    pathModel.paths.removeLast()
                },
                trailingButtonAction: {
                    print(todoViewModel.title)
                    print(todoViewModel.time)
                    print(todoViewModel.day)
                    
                    todoListViewModel.addTodo(
                        todo: .init(
                            title: todoViewModel.title,
                            time: todoViewModel.time,
                            day: todoViewModel.day,
                            selected: false
                        )
                    )
                    pathModel.paths.removeLast()
                },
                type: .create
            )
            ScrollView {
                TitleView()
                    .padding(.top, 20)
                TodoTitleView(todoViewModel: todoViewModel)
                    .padding(.top, 20)
                
                SelectTimeView(todoViewModel: todoViewModel)
                    .padding(.vertical, 30)
                
                SelectDayView(todoViewModel: todoViewModel)
            }
            // TODO : TextField 입력시, Keyboard가 View 덮는거 해결해야함
        }
    }
}

private struct TitleView: View {
    fileprivate var body: some View {
        HStack {
            Text("To do list를\n추가해 보세요.")
                .font(.system(size: 30, weight: .bold))
                .padding(.leading, 20)
            Spacer()
        }
    }
}

private struct TodoTitleView: View {
    @ObservedObject private var todoViewModel: TodoViewModel
    
    fileprivate init(todoViewModel: TodoViewModel) {
        self.todoViewModel = todoViewModel
    }
    
    fileprivate var body: some View {
        TextField(
            "제목을 입력하세요",
            text: $todoViewModel.title
        )
        .font(.system(size: 18))
        .padding(.leading, 20)
    }
}

private struct SelectTimeView: View {
    @ObservedObject private var todoViewModel: TodoViewModel
    
    fileprivate init(todoViewModel: TodoViewModel) {
        self.todoViewModel = todoViewModel
    }
    
    fileprivate var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(.customGray0)
                .frame(height: 1)
            
            DatePicker(
                "",
                selection: $todoViewModel.time,
                displayedComponents: [.hourAndMinute]
            )
            .labelsHidden()
            .datePickerStyle(WheelDatePickerStyle())
            
            Rectangle()
                .fill(.customGray0)
                .frame(height: 1)
        }
    }
}

private struct SelectDayView: View {
    @ObservedObject private var todoViewModel: TodoViewModel
    
    fileprivate init(todoViewModel: TodoViewModel) {
        self.todoViewModel = todoViewModel
    }
    
    fileprivate var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text("날짜")
                    .foregroundColor(.customIconOn)
                
                Spacer()
            }
            HStack {
                Button {
                    todoViewModel.showIsShowCalendar(isShow: true)
                } label: {
                    Text(todoViewModel.day.formattedDay)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.customGreen)
                }
                .popover(isPresented: $todoViewModel.isShowCalendar) {
                    DatePicker(
                        "",
                        selection: $todoViewModel.day,
                        displayedComponents: [.date]
                    )
                    .labelsHidden()
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                    .onChange(of: todoViewModel.day) { _ in
                        todoViewModel.showIsShowCalendar(isShow: false)
                    }
                }
                Spacer()
            }
        }.padding(.leading, 20)
    }
}

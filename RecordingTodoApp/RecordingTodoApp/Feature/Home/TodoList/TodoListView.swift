//
 //  TodoListView.swift
 //  RecordingTodoApp
 //
 //  Created by 김동준 on 12/30/23
 //

import Foundation
import SwiftUI

struct TodoListView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                if (!todoListViewModel.todos.isEmpty) {
                    CustomNavigationBar(
                        isShowTrailingButton: true,
                        trailingButtonAction: {
                            todoListViewModel.navigationTrailingButtonTapped()
                        },
                        type: todoListViewModel.navigationBarType
                    )
                }
                TitleView()
                    .padding(.top, 20)
                
                if (todoListViewModel.todos.isEmpty) {
                    AnnouncementView()
                } else {
                    TodoListContentView()
                        .padding(.top, 24)
                        .padding(.bottom, 12)
                }
            }
            WirteTodoButtonView()
                .padding(.trailing, 20)
                .padding(.bottom, 50)
        }
        .onChange(
            of: todoListViewModel.todos,
            perform: { todos in
                homeViewModel.todosCount = todos.count
            }
        )
        .alert(
            "To do list \(todoListViewModel.removeTodosCount)개 삭제하시겠습니까?",
            isPresented: $todoListViewModel.isPresentedDialog
        ) {
            Button("삭제", role: .destructive) {
                todoListViewModel.removeButtonTapped()
            }
            Button("취소", role: .cancel) {}
        }
    }
}

private struct TitleView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    fileprivate var body: some View {
        HStack {
            if (todoListViewModel.todos.isEmpty) {
                Text("To do list를\n추가해 보세요.")
                    .font(.system(size: 30, weight: .bold))
                    .padding(.leading, 20)
            } else {
                Text("To do list \(todoListViewModel.todos.count)개가\n있습니다.")
                    .font(.system(size: 30, weight: .bold))
                    .padding(.leading, 20)
            }
            Spacer()
        }
    }
}

private struct AnnouncementView: View {
    fileprivate var body: some View {
        VStack(spacing: 15) {
            Spacer()
            Image("pencil")
                .renderingMode(.template)
            Text("\"매일 아침 5시 운동 고고~\"")
            Text("\"내일 8시 수강 신청하자\"")
            Text("\"1시 반 점심약속 리마인드!!\"")
            Spacer()
        }
        .font(.system(size: 16))
        .foregroundColor(.customGray2)
    }
}

private struct TodoListContentView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    fileprivate var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("할일 목록")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.leading, 20)
                
                Spacer()
            }
            
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.customGray0)
                        .frame(height: 1)
                    
                    ForEach(todoListViewModel.todos, id: \.self) { todo in
                        TodoCellItem(todo: todo)
                    }
                }
            }
        }
    }
}

private struct TodoCellItem: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @State private var isRemoveSelected: Bool
    private var todo: Todo
    
    fileprivate init(
        isRemoveSelected: Bool = false,
        todo: Todo
    ) {
        _isRemoveSelected = State(initialValue: isRemoveSelected)
        self.todo = todo
    }
    
    fileprivate var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 0) {
                if !todoListViewModel.isEditable {
                    Button {
                        todoListViewModel.selectedCheckdBoxTapped(todo: todo)
                    } label: {
                        todo.selected
                        ? Image("selectedCheckBox")
                        : Image("unSelectedCheckBox")
                    }
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(todo.title)
                        .font(.system(size: 16))
                        .foregroundColor(todo.selected ? .customIconOn : .customBK)
                        .strikethrough(todo.selected)
                    
                    Text(todo.convertedDayAndTime)
                        .font(.system(size: 16))
                        .foregroundColor(todo.selected ? .customIconOn : .customBK)
                        .strikethrough(todo.selected)
                        .padding(.bottom, 5)
                }.padding(.leading, 24)
                
                Spacer()
                
                if (todoListViewModel.isEditable) {
                    Button {
                        isRemoveSelected.toggle()
                        todoListViewModel.removeTodoTapped(todo: todo)
                    } label: {
                        isRemoveSelected
                        ? Image("selectedCheckBox")
                        : Image("unSelectedCheckBox")
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        
        Rectangle()
            .fill(.customGray0)
            .frame(height: 1)
    }
}

private struct WirteTodoButtonView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                Button{
                    pathModel.paths.append(.todoView)
                } label: {
                    Image("writeButton")
                }
            }
        }
    }
}

struct TodoListView_Preivews: PreviewProvider {
    static var previews: some View {
        TodoListView()
            .environmentObject(PathModel())
            .environmentObject(TodoListViewModel())
    }
}

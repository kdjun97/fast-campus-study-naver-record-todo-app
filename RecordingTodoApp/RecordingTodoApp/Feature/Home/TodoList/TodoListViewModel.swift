//
 //  TodoListViewModel.swift
 //  RecordingTodoApp
 //
 //  Created by 김동준 on 12/30/23
 //

import Foundation

class TodoListViewModel: ObservableObject {
    @Published var todos: [Todo]
    @Published var isEditable: Bool
    @Published var removeTodos: [Todo]
    @Published var isPresentedDialog: Bool
    
    var removeTodosCount: Int {
        return removeTodos.count
    }
    
    var navigationBarType: CustomNavigationBarType {
        isEditable ? .complete : .edit
    }
    
    init(
        todos: [Todo] = [],
        isEditable: Bool = false,
        removeTodos: [Todo] = [],
        isPresentedDialog: Bool = false
    ) {
        self.todos = todos
        self.isEditable = isEditable
        self.removeTodos = removeTodos
        self.isPresentedDialog = isPresentedDialog
    }
}

extension TodoListViewModel {
    func selectedCheckdBoxTapped(todo: Todo) {
        if let index = todos.firstIndex(where: { $0 == todo }) {
            todos[index].selected.toggle()
        }
    }
    
    func addTodo(todo: Todo) {
        todos.append(todo)
    }
    
    func navigationTrailingButtonTapped() {
        if (isEditable) {
            if (removeTodos.isEmpty) {
                isEditable = false
            } else {
                setIsPresentedDialog(isShow: true)
            }
        } else {
            isEditable = true
        }
    }
    
    func setIsPresentedDialog(isShow: Bool) {
        isPresentedDialog = isShow
    }
    
    func removeTodoTapped(todo: Todo) {
        if let index = removeTodos.firstIndex(of: todo) {
            removeTodos.remove(at: index)
        } else {
            removeTodos.append(todo)
        }
    }
    
    func removeButtonTapped() {
        todos.removeAll { todo in
            removeTodos.contains(todo)
        }
        removeTodos.removeAll()
        isEditable = false
    }
}

//
//  SimpleTodo.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 2/9/26.
//

import SwiftUI
import CoreData
import Combine


class SimpleTodoViewModel: ObservableObject {
    
    let container: NSPersistentContainer
    
    @Published var savedEntities: [TodoItem] = []
    
    init() {
        container = NSPersistentContainer(name: "SimpleTodoStorage")
        
        container.loadPersistentStores { (description, error) in
            if let error {
                print(error)
            } else {
                print("loading storage successfully")
                self.fetchTodo()
            }
        }
    }
    
    private func fetchTodo() {
        let request = NSFetchRequest<TodoItem>(entityName: "TodoItem")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TodoItem.createdAt, ascending: false)]
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch {
            print("Fetching From CoreData Error")
        }
    }
    
    func saveTodo() {
        do {
            try container.viewContext.save()
            self.fetchTodo()
        } catch {
            print("Error Saving in Core Data")
        }
    }
    
    func addTodo(memoTitle: String) {
        let newTodo = TodoItem(context: container.viewContext)
        newTodo.id = UUID()
        newTodo.title = memoTitle
        newTodo.createdAt = Date()
        
        saveTodo()
    }
    
    func updateTodo(todo: TodoItem) {
        todo.isCompleted.toggle()
        saveTodo()
    }
    
    func deleteTodo(offsets: IndexSet) {
        guard let index = offsets.first else {return}
        let selectedTodo = savedEntities[index]
        container.viewContext.delete(selectedTodo)
        saveTodo()
    }
}

struct SimpleTodo: View {
    
    @StateObject private var vm = SimpleTodoViewModel()
    @State private var todoString: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("할 일 입력", text: $todoString)
                    .withDefaultTextField()
                
                Button("추가하기") {
                    //action addTodo()
                    guard !todoString.isEmpty else {return}
                    vm.addTodo(memoTitle: todoString)
                    todoString = ""
                }
                .withDefaultButton()
                
                List {
                    ForEach(vm.savedEntities) { todoItem in
                        HStack(spacing: 10) {
                            Image(systemName: todoItem.isCompleted ? "checkmark.square" : "square")
                            Text(todoItem.title ?? "할 일 없음")
                                .strikethrough(todoItem.isCompleted)
                                .foregroundStyle(todoItem.isCompleted ? Color.gray : .black)
                                .onTapGesture {
                                    vm.updateTodo(todo: todoItem)
                                }
                        } //:HSTACK
                    } //:LOOP
                    .onDelete(perform: vm.deleteTodo)
                } //:LIST
            } //:VSTACK
            .navigationTitle("할일 관리")
        } //:NAVIGATION
    }//: body
}

#Preview {
    SimpleTodo()
}

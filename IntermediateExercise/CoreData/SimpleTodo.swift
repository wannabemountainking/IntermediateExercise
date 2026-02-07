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
                fetchTodo()
            }
        }
    }
    
    private func fetchTodo() {
        let request = NSFetchRequest<TodoItem>(entityName: "TodoItem")
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch {
            print("Fetching From CoreData Error")
        }
    }
    
    func saveTodo() {
        do {
            try container.viewContext.save()
            fetchTodo()
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
}

struct SimpleTodo: View {
    
    @State private var todoString: String = ""
    
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("추가하기", text: $todoString)
                .withDefaultTextField()
            
            Button("추가") {
                //action addTodo()
            }
            .withDefaultButton()
            
            List {
                ForEach(<#T##data: RandomAccessCollection##RandomAccessCollection#>, id: <#T##KeyPath<RandomAccessCollection.Element, Hashable>#>, content: <#T##(RandomAccessCollection.Element) -> View#>)
            }
        }
    }
}

#Preview {
    SimpleTodo()
}

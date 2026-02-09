//
//  ExpenditureHistory.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 2/10/26.
//

import SwiftUI
import Combine
import CoreData



class ExpenseHistoryViewModel: ObservableObject {
    let container: NSPersistentContainer
    
    @Published var selectedExpense: [Expense] = []
    @Published var totalExpense: Double = 0
    @Published var categoryExpense: [String: Double] = [
        "식비": 0, "교통비": 0, "쇼핑": 0
    ]
    
    init() {
        container = NSPersistentContainer(name: "ExpenseRecord")
        
        container.loadPersistentStores { [weak self] (description, error) in
            guard let self else {return}
            if let error {
                print("Error Loading Core Data: \(error)")
            } else {
                print("Successfully Core Data Loaded: \(description)")
                self.fetchExpense()
            }
        }
    }
    
    private func fetchExpense() {
        let request = NSFetchRequest<Expense>(entityName: "Expense")
        do {
            selectedExpense = try container.viewContext.fetch(request)
        } catch {
            print("Fetching Core Data Failed: \(error)")
        }
    }
    
    private func saveExpense() {
        do {
            try container.viewContext.save()
            fetchExpense()
        } catch {
            print("Saving Error: \(error)")
        }
    }
    
    func createExpense(amount: Double, category: String, memo: String? = nil) {
        let newExpense = Expense(context: container.viewContext)
        newExpense.id = UUID()
        newExpense.date = Date()
        newExpense.amount = amount
        newExpense.category = category
        newExpense.memo = memo
        
        saveExpense()
    }
    
    func deleteExpense(offsets: IndexSet) {
        offsets.map { selectedExpense[$0] }.forEach(container.viewContext.delete)
        saveExpense()
    }
    
    // MARK: - Expense Function
    func CalcCategoryExpense() {
        for category in categoryExpense.keys {
            let expenses = selectedExpense
                .compactMap { $0.category == category ? $0.amount : nil }
                .reduce(0) { $0 + $1 }
            categoryExpense[category] = expenses
        }
    }
    
    func listOfCategoryExpense(category: String) -> [String: Double] {
        var result: [String: Double] = [:]
        let categoryResult = selectedExpense.filter { $0.category == category }
        for item in categoryResult {
            result[item.memo ?? "미분류"] = item.amount
        }
        return result
    }
}

struct ExpenditureHistory: View {
    
    @State private var amountOfExpense: String = ""
    @State private var selectedCategory: String = "쇼핑"
    @State private var expenseComment: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 30) {
                HStack(spacing: 10) {
                    Text("금액:")
                    TextField("여기에 입력...", text: $amountOfExpense)
                        .withDefaultTextField()
                    Text("원")
                }
                    
                Picker("카테고리", selection: $selectedCategory) {
                    Text("식비").tag("식비")
                    Text("교통비").tag("교통비")
                    Text("쇼핑").tag("쇼핑")
                }
                .pickerStyle(.segmented)
                
                HStack(spacing: 10) {
                    Text("메모:")
                    TextField("여기에 입력...", text: $expenseComment)
                        .withDefaultTextField()
                }
                
                Divider()
                
                
                
            } //:VSTACK
            .padding(20)
            .navigationTitle("지출 기록")
        } //:NAVIGATION
    }//:body
}

#Preview {
    ExpenditureHistory()
}


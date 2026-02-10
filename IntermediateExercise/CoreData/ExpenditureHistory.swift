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
    
    struct CategoryData: Identifiable {
        let id = UUID()
        let categoryName: String
        let expenses: [Expense]
        let subtotal: Double
    }
    
    let container: NSPersistentContainer
    
    @Published var selectedExpense: [Expense] = []
    
    var totalExpense: Double {
        selectedExpense.map { $0.amount }.reduce(0, +)
    }
    
    var categoriesWithSubtotal: [CategoryData] {
        let grouped = Dictionary(grouping: selectedExpense) { $0.category ?? "미분류" }
        
        return grouped
            .map { CategoryData(
                categoryName: $0.key,
                expenses: $0.value.sorted(by: { $0.date ?? Date() < $1.date ?? Date() }),
                subtotal: $0.value.map { $0.amount }.reduce(0.0, +)
            ) }
            .sorted(by: { $0.categoryName < $1.categoryName })
    }
    
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
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Expense.date, ascending: false)]
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
    
    func deleteExpense(_ expense: Expense) {
        container.viewContext.delete(expense)
        saveExpense()
    }
    
    
}

struct ExpenditureHistory: View {
    
    @StateObject private var vm = ExpenseHistoryViewModel()
    
    @State private var amountOfExpense: String = ""
    @State private var selectedCategory: String = "쇼핑"
    @State private var expenseComment: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
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
                .pickerStyle(.palette)
                
                HStack(spacing: 10) {
                    Text("메모:")
                    TextField("여기에 입력...", text: $expenseComment)
                        .withDefaultTextField()
                }
                
                Button("저장하기") {
                    //action createExpense() / textfield = "", selectedCategory, expenseComment 초기화
                    vm.createExpense(
                        amount: Double(amountOfExpense) ?? 0.0,
                        category: selectedCategory,
                        memo: expenseComment
                    )
                    amountOfExpense = ""
                    selectedCategory = "쇼핑"
                    expenseComment = ""
                }
                .withDefaultButton()
                
                Divider()
                
                Text("📊 총 지출: \(vm.totalExpense, specifier: "%.0f")원")
                
                List {
                    ForEach(vm.categoriesWithSubtotal, id: \.id) { categoryData in
                        Section {
                            //content
                            ForEach(categoryData.expenses, id: \.id) { expense in
                                HStack {
                                    Text(expense.memo ?? "미분류")
                                    Spacer()
                                    Text("- \(expense.amount, specifier: "%.0f")원")
                                }
                                .frame(width: 300)
                            }
                            .onDelete { offsets in
                                offsets.map { categoryData.expenses[$0] }.forEach(vm.deleteExpense)
                            }
                        } header: {
                            HStack {
                                Text("[\(categoryData.categoryName)]")
                                Spacer()
                                Text("\(categoryData.subtotal, specifier: "%.0f")원")
                            }
                            .frame(width: 300)
                        }

                    }

                }
                
                Spacer()
            } //:VSTACK
            .font(.title2)
            .padding(20)
            .navigationTitle("지출 기록")
        } //:NAVIGATION
    }//:body
}

#Preview {
    ExpenditureHistory()
}


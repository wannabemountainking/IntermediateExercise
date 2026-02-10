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
        "식비" : 0, "교통비": 0, "쇼핑": 0
    ]
    @Published var expensesDetails: [String: [(name: String, price: Double)]] = [
        "식비" : [(name: "", price: 0.0)],
        "교통비": [(name: "", price: 0.0)],
        "쇼핑": [(name: "", price: 0.0)]
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
            runExpenses()
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
    
    func runExpenses() {
        // 1. expensesDetails
        // 2. categoryExpense
        // 3. totalExpense
        expensesDetails = selectedExpense
            .reduce(
                into: [:],
                {
                    $0[$1.category ?? "분류기준추가요망", default: [(name: String, price: Double)]()]
                        .append((name: $1.memo ?? "미분류", price: $1.amount))
                }
            )
        print(expensesDetails)
        categoryExpense = expensesDetails.mapValues { $0.map { $0.price }.reduce(0, +) }
        print(categoryExpense)
        totalExpense = categoryExpense.map { $1 }.reduce(0, +)
        print(totalExpense)
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
                
                Text("📊 총 지출: \(vm.totalExpense.formatted(.number.precision(.fractionLength(0))))원")
                
                ForEach(vm.categoryExpense.sorted(by: { $0.key < $1.key }), id: \.key) { category, price in
                    HStack {
                        Text("[\(category)]")
                        Spacer()
                        Text("\(vm.categoryExpense[category, default: 0.0], specifier: "%.0f")원")
                    }
                    .frame(width: 300)
                    
                    ForEach(vm.expensesDetails[category, default: [(name: String, price: Double)]()].sorted(by: { $0.name < $1.name }), id: \.price) { name, individualPrice in
                        HStack {
                            Text(name)
                            Spacer()
                            Text("- \(individualPrice, specifier: "%.0f")원")
                        }
                        .frame(width: 300)
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


//
//  BankingTradeAnalysis.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 1/21/26.
//

import SwiftUI
import Combine


enum TransactionType: String, Identifiable {
    case deposit = "수입"
    case withdrawal = "지출"
    case transfer = "이체"
    
    var id: String {
        switch self {
        case .deposit: return "deposit"
        case .withdrawal: return "withdrawal"
        case .transfer: return "transfer"
        }
    }
}

enum categoryType: String, Identifiable {
    case food = "식비"
    case tranportation = "교통비"
    case shopping = "쇼핑"
    case education = "교육비"
    case salary = "월급"
    case rantalIncome = "임대수입"
    case dividends = "주식배당금"
    case appRevenue = "앱수익금"
    
    var id: String {
        switch self {
        case .food: return "food"
        case .tranportation: return "transportation"
        case .shopping: return "shopping"
        case .education: return "education"
        case .salary: return "salary"
        case .rantalIncome: return "rantalIncome"
        case .dividends: return "dividends"
        case .appRevenue: return "appRevenue"
        }
    }
}

struct Transaction: Identifiable {
    let id = UUID()
    let date: Date
    let amount: Int
    var type: TransactionType
    var category: categoryType?
    var memo: String?
}

enum DisplayMode: String, CaseIterable {
    case none
    case withdrawalOnly = "출금 내역"
    case formattedAmounts = "거래금액에 1,000 단위 구분 쉼표 추가"
    case totalExpenditureInMonth = "한 달 총 지출액"
    case transactionWithCategory = "카테고리가 입력된 거래"
    case meanValueOfFoodExpenditure = "식비 중 상위 10건의 큰 금액의 평균"
}

class TransactionViewModel: ObservableObject {
    var transactions: [Transaction] = []
    
    init() {
        self.transactionInitiate()
    }
    
    //1. filter: 출금(withdrawal) 내역만 추출
    var withdrawalOnly: [Transaction] {
        transactions.filter { $0.type == .withdrawal }
    }
    
    //2. map: 거래금액에 1,000원 단위 구분 쉼표 추가한 문자열로 변환
    var formattedAmounts: [String] {
        transactions.map { transactions in
            transactions.amount.formatted(.number.grouping(.automatic))
        }
    }
    
    // 3. reduce: 한 달 총 지출액 계산
    var totalExpenditureInMonth: Int {
        transactions
            .filter { $0.type == .withdrawal }
            .reduce(0) { $0 + $1.amount}
    }
    
    // 4. compactMap: 카테고리가 입력된 거래만 추출
    var transactionWithCategory: [Transaction] {
        transactions.compactMap { transaction in
            guard let _ = transaction.category else { return nil }
            return transaction
        }
    }
    
    /* 5. 복합:
       - 출금 거래 중
       - 카테고리가 "식비"
       - 금액 큰 순 정렬
       - 상위 10건의 평균 금액 계산 (reduce 활용)
    */
    var meanValueOfFoodExpenditure: Int {
        let top10 = transactions
            .filter { $0.type == .withdrawal && $0.category == .food }
            .sorted(by: { $0.amount > $1.amount })
            .prefix(10)
        guard !top10.isEmpty else { return 0 }
        let sum = top10.reduce(0) { $0 + $1.amount }
        return sum / top10.count
    }
    
    private func transactionInitiate() {
        let calendar = Calendar.current
        let today = Date()
        
        transactions = [
            Transaction(date: calendar.date(byAdding: .day, value: -1, to: today)!, amount: 3500000, type: .deposit, category: .salary, memo: "1월 급여"),
            Transaction(date: calendar.date(byAdding: .day, value: -1, to: today)!, amount: 850000, type: .withdrawal, category: .shopping, memo: "에어팟 프로"),
            Transaction(date: calendar.date(byAdding: .day, value: -2, to: today)!, amount: 45000, type: .withdrawal, category: .food, memo: "회식"),
            Transaction(date: calendar.date(byAdding: .day, value: -2, to: today)!, amount: 500000, type: .transfer, category: nil, memo: "적금"),
            Transaction(date: calendar.date(byAdding: .day, value: -3, to: today)!, amount: 12000, type: .withdrawal, category: .food, memo: "점심"),
            Transaction(date: calendar.date(byAdding: .day, value: -3, to: today)!, amount: 5500, type: .withdrawal, category: .food, memo: "커피"),
            Transaction(date: calendar.date(byAdding: .day, value: -4, to: today)!, amount: 850000, type: .withdrawal, category: .shopping, memo: "월세"),
            Transaction(date: calendar.date(byAdding: .day, value: -4, to: today)!, amount: 35000, type: .withdrawal, category: .food, memo: "장보기"),
            Transaction(date: calendar.date(byAdding: .day, value: -5, to: today)!, amount: 8000, type: .withdrawal, category: .tranportation, memo: "택시"),
            Transaction(date: calendar.date(byAdding: .day, value: -5, to: today)!, amount: 15000, type: .withdrawal, category: .food, memo: "저녁"),
            
            Transaction(date: calendar.date(byAdding: .day, value: -6, to: today)!, amount: 4500, type: .withdrawal, category: .food, memo: "아침"),
            Transaction(date: calendar.date(byAdding: .day, value: -7, to: today)!, amount: 120000, type: .withdrawal, category: .shopping, memo: "의류"),
            Transaction(date: calendar.date(byAdding: .day, value: -8, to: today)!, amount: 6500, type: .withdrawal, category: .food, memo: "카페"),
            Transaction(date: calendar.date(byAdding: .day, value: -9, to: today)!, amount: 95000, type: .withdrawal, category: .shopping, memo: "책"),
            Transaction(date: calendar.date(byAdding: .day, value: -10, to: today)!, amount: 13000, type: .withdrawal, category: .food, memo: "점심"),
            Transaction(date: calendar.date(byAdding: .day, value: -11, to: today)!, amount: 80000, type: .deposit, category: .dividends, memo: "배당금"),
            Transaction(date: calendar.date(byAdding: .day, value: -12, to: today)!, amount: 7800, type: .withdrawal, category: .tranportation, memo: "지하철"),
            Transaction(date: calendar.date(byAdding: .day, value: -13, to: today)!, amount: 28000, type: .withdrawal, category: .food, memo: "치킨"),
            Transaction(date: calendar.date(byAdding: .day, value: -14, to: today)!, amount: 150000, type: .withdrawal, category: .education, memo: "강의"),
            Transaction(date: calendar.date(byAdding: .day, value: -15, to: today)!, amount: 12000, type: .withdrawal, category: .food, memo: "점심"),
            
            Transaction(date: calendar.date(byAdding: .day, value: -16, to: today)!, amount: 65000, type: .withdrawal, category: .shopping, memo: "화장품"),
            Transaction(date: calendar.date(byAdding: .day, value: -17, to: today)!, amount: 9500, type: .withdrawal, category: .food, memo: "브런치"),
            Transaction(date: calendar.date(byAdding: .day, value: -18, to: today)!, amount: 42000, type: .withdrawal, category: .food, memo: "회식"),
            Transaction(date: calendar.date(byAdding: .day, value: -19, to: today)!, amount: 15000, type: .withdrawal, category: .tranportation, memo: "버스카드 충전"),
            Transaction(date: calendar.date(byAdding: .day, value: -20, to: today)!, amount: 350000, type: .withdrawal, category: .shopping, memo: "신발"),
            Transaction(date: calendar.date(byAdding: .day, value: -21, to: today)!, amount: 8000, type: .withdrawal, category: .food, memo: "아침"),
            Transaction(date: calendar.date(byAdding: .day, value: -22, to: today)!, amount: 180000, type: .withdrawal, category: .education, memo: "온라인 강의"),
            Transaction(date: calendar.date(byAdding: .day, value: -23, to: today)!, amount: 25000, type: .withdrawal, category: .food, memo: "저녁"),
            Transaction(date: calendar.date(byAdding: .day, value: -24, to: today)!, amount: 5500, type: .withdrawal, category: .food, memo: "커피"),
            Transaction(date: calendar.date(byAdding: .day, value: -25, to: today)!, amount: 78000, type: .withdrawal, category: .shopping, memo: "생활용품"),
            
            Transaction(date: calendar.date(byAdding: .day, value: -26, to: today)!, amount: 32000, type: .withdrawal, category: .food, memo: "외식"),
            Transaction(date: calendar.date(byAdding: .day, value: -27, to: today)!, amount: 11000, type: .withdrawal, category: .food, memo: "점심"),
            Transaction(date: calendar.date(byAdding: .day, value: -28, to: today)!, amount: 200000, type: .transfer, category: nil, memo: "부모님"),
            Transaction(date: calendar.date(byAdding: .day, value: -29, to: today)!, amount: 14500, type: .withdrawal, category: .food, memo: "분식"),
            Transaction(date: calendar.date(byAdding: .day, value: -30, to: today)!, amount: 6000, type: .withdrawal, category: .tranportation, memo: "택시"),
            
            Transaction(date: calendar.date(byAdding: .day, value: -31, to: today)!, amount: 3500000, type: .deposit, category: .salary, memo: "12월 급여"),
            Transaction(date: calendar.date(byAdding: .day, value: -32, to: today)!, amount: 500000, type: .transfer, category: nil, memo: "적금"),
            Transaction(date: calendar.date(byAdding: .day, value: -33, to: today)!, amount: 850000, type: .withdrawal, category: .shopping, memo: "월세"),
            Transaction(date: calendar.date(byAdding: .day, value: -34, to: today)!, amount: 145000, type: .withdrawal, category: .food, memo: "마트"),
            Transaction(date: calendar.date(byAdding: .day, value: -35, to: today)!, amount: 12000, type: .withdrawal, category: .food, memo: "점심"),
            Transaction(date: calendar.date(byAdding: .day, value: -36, to: today)!, amount: 6500, type: .withdrawal, category: .food, memo: "커피"),
            Transaction(date: calendar.date(byAdding: .day, value: -37, to: today)!, amount: 280000, type: .withdrawal, category: .shopping, memo: "코트"),
            Transaction(date: calendar.date(byAdding: .day, value: -38, to: today)!, amount: 15000, type: .withdrawal, category: .food, memo: "저녁"),
            Transaction(date: calendar.date(byAdding: .day, value: -39, to: today)!, amount: 32000, type: .withdrawal, category: .food, memo: "외식"),
            Transaction(date: calendar.date(byAdding: .day, value: -40, to: today)!, amount: 7800, type: .withdrawal, category: .tranportation, memo: "버스"),
            
            Transaction(date: calendar.date(byAdding: .day, value: -41, to: today)!, amount: 95000, type: .withdrawal, category: .shopping, memo: "선물"),
            Transaction(date: calendar.date(byAdding: .day, value: -42, to: today)!, amount: 12500, type: .withdrawal, category: .food, memo: "점심"),
            Transaction(date: calendar.date(byAdding: .day, value: -43, to: today)!, amount: 5500, type: .withdrawal, category: .food, memo: "커피"),
            Transaction(date: calendar.date(byAdding: .day, value: -44, to: today)!, amount: 38000, type: .withdrawal, category: .food, memo: "회식"),
            Transaction(date: calendar.date(byAdding: .day, value: -45, to: today)!, amount: 125000, type: .withdrawal, category: .shopping, memo: "가전제품"),
            Transaction(date: calendar.date(byAdding: .day, value: -46, to: today)!, amount: 9000, type: .withdrawal, category: .food, memo: "아침"),
            Transaction(date: calendar.date(byAdding: .day, value: -47, to: today)!, amount: 220000, type: .withdrawal, category: .education, memo: "교재"),
            Transaction(date: calendar.date(byAdding: .day, value: -48, to: today)!, amount: 18000, type: .withdrawal, category: .food, memo: "저녁"),
            Transaction(date: calendar.date(byAdding: .day, value: -49, to: today)!, amount: 350000, type: .deposit, category: .rantalIncome, memo: "월세 수입"),
            Transaction(date: calendar.date(byAdding: .day, value: -50, to: today)!, amount: 45000, type: .withdrawal, category: .shopping, memo: "잡화"),
            
            Transaction(date: calendar.date(byAdding: .day, value: -51, to: today)!, amount: 13000, type: .withdrawal, category: .food, memo: "점심"),
            Transaction(date: calendar.date(byAdding: .day, value: -52, to: today)!, amount: 8500, type: .withdrawal, category: .tranportation, memo: "택시"),
            Transaction(date: calendar.date(byAdding: .day, value: -53, to: today)!, amount: 52000, type: .withdrawal, category: .food, memo: "외식"),
            Transaction(date: calendar.date(byAdding: .day, value: -54, to: today)!, amount: 6500, type: .withdrawal, category: .food, memo: "커피"),
            Transaction(date: calendar.date(byAdding: .day, value: -55, to: today)!, amount: 175000, type: .withdrawal, category: .shopping, memo: "운동화"),
            Transaction(date: calendar.date(byAdding: .day, value: -56, to: today)!, amount: 11000, type: .withdrawal, category: .food, memo: "점심"),
            Transaction(date: calendar.date(byAdding: .day, value: -57, to: today)!, amount: 85000, type: .withdrawal, category: .shopping, memo: "가방"),
            Transaction(date: calendar.date(byAdding: .day, value: -58, to: today)!, amount: 14000, type: .withdrawal, category: .food, memo: "저녁"),
            Transaction(date: calendar.date(byAdding: .day, value: -59, to: today)!, amount: 5500, type: .withdrawal, category: .food, memo: "커피"),
            Transaction(date: calendar.date(byAdding: .day, value: -60, to: today)!, amount: 300000, type: .transfer, category: nil, memo: "비상금"),
            
            Transaction(date: calendar.date(byAdding: .day, value: -61, to: today)!, amount: 3500000, type: .deposit, category: .salary, memo: "11월 급여"),
            Transaction(date: calendar.date(byAdding: .day, value: -62, to: today)!, amount: 500000, type: .transfer, category: nil, memo: "적금"),
            Transaction(date: calendar.date(byAdding: .day, value: -63, to: today)!, amount: 850000, type: .withdrawal, category: .shopping, memo: "월세"),
            Transaction(date: calendar.date(byAdding: .day, value: -64, to: today)!, amount: 98000, type: .withdrawal, category: .food, memo: "마트"),
            Transaction(date: calendar.date(byAdding: .day, value: -65, to: today)!, amount: 12000, type: .withdrawal, category: .food, memo: "점심"),
            Transaction(date: calendar.date(byAdding: .day, value: -66, to: today)!, amount: 6500, type: .withdrawal, category: .food, memo: "커피"),
            Transaction(date: calendar.date(byAdding: .day, value: -67, to: today)!, amount: 145000, type: .withdrawal, category: .shopping, memo: "의류"),
            Transaction(date: calendar.date(byAdding: .day, value: -68, to: today)!, amount: 22000, type: .withdrawal, category: .food, memo: "저녁"),
            Transaction(date: calendar.date(byAdding: .day, value: -69, to: today)!, amount: 9500, type: .withdrawal, category: .tranportation, memo: "택시"),
            Transaction(date: calendar.date(byAdding: .day, value: -70, to: today)!, amount: 13500, type: .withdrawal, category: .food, memo: "점심"),
            
            Transaction(date: calendar.date(byAdding: .day, value: -71, to: today)!, amount: 78000, type: .withdrawal, category: .shopping, memo: "주방용품"),
            Transaction(date: calendar.date(byAdding: .day, value: -72, to: today)!, amount: 5500, type: .withdrawal, category: .food, memo: "커피"),
            Transaction(date: calendar.date(byAdding: .day, value: -73, to: today)!, amount: 190000, type: .withdrawal, category: .education, memo: "수강료"),
            Transaction(date: calendar.date(byAdding: .day, value: -74, to: today)!, amount: 16000, type: .withdrawal, category: .food, memo: "저녁"),
            Transaction(date: calendar.date(byAdding: .day, value: -75, to: today)!, amount: 12000, type: .withdrawal, category: .food, memo: "점심"),
            Transaction(date: calendar.date(byAdding: .day, value: -76, to: today)!, amount: 7500, type: .withdrawal, category: .tranportation, memo: "버스"),
            Transaction(date: calendar.date(byAdding: .day, value: -77, to: today)!, amount: 43000, type: .withdrawal, category: .food, memo: "회식"),
            Transaction(date: calendar.date(byAdding: .day, value: -78, to: today)!, amount: 6500, type: .withdrawal, category: .food, memo: "커피"),
            Transaction(date: calendar.date(byAdding: .day, value: -79, to: today)!, amount: 125000, type: .withdrawal, category: .shopping, memo: "화장품"),
            Transaction(date: calendar.date(byAdding: .day, value: -80, to: today)!, amount: 120000, type: .deposit, category: .appRevenue, memo: "앱 광고 수익"),
            
            Transaction(date: calendar.date(byAdding: .day, value: -81, to: today)!, amount: 350000, type: .deposit, category: .rantalIncome, memo: "월세 수입"),
            Transaction(date: calendar.date(byAdding: .day, value: -82, to: today)!, amount: 88000, type: .withdrawal, category: .shopping, memo: "인테리어"),
            Transaction(date: calendar.date(byAdding: .day, value: -83, to: today)!, amount: 14000, type: .withdrawal, category: .food, memo: "저녁"),
            Transaction(date: calendar.date(byAdding: .day, value: -84, to: today)!, amount: 5500, type: .withdrawal, category: .food, memo: "커피"),
            Transaction(date: calendar.date(byAdding: .day, value: -85, to: today)!, amount: 32000, type: .withdrawal, category: .food, memo: "외식"),
            Transaction(date: calendar.date(byAdding: .day, value: -86, to: today)!, amount: 9000, type: .withdrawal, category: .tranportation, memo: "택시"),
            Transaction(date: calendar.date(byAdding: .day, value: -87, to: today)!, amount: 165000, type: .withdrawal, category: .shopping, memo: "전자기기"),
            Transaction(date: calendar.date(byAdding: .day, value: -88, to: today)!, amount: 12000, type: .withdrawal, category: .food, memo: "점심"),
            Transaction(date: calendar.date(byAdding: .day, value: -89, to: today)!, amount: 6500, type: .withdrawal, category: .food, memo: "커피"),
            Transaction(date: calendar.date(byAdding: .day, value: -90, to: today)!, amount: 3500000, type: .deposit, category: .salary, memo: "10월 급여"),
            
            Transaction(date: calendar.date(byAdding: .day, value: -91, to: today)!, amount: 500000, type: .transfer, category: nil, memo: "적금"),
            Transaction(date: calendar.date(byAdding: .day, value: -92, to: today)!, amount: 850000, type: .withdrawal, category: .shopping, memo: "월세"),
            Transaction(date: calendar.date(byAdding: .day, value: -93, to: today)!, amount: 112000, type: .withdrawal, category: .food, memo: "마트"),
            Transaction(date: calendar.date(byAdding: .day, value: -94, to: today)!, amount: 13000, type: .withdrawal, category: .food, memo: "점심"),
            Transaction(date: calendar.date(byAdding: .day, value: -95, to: today)!, amount: 210000, type: .withdrawal, category: .education, memo: "자격증"),
            Transaction(date: calendar.date(byAdding: .day, value: -96, to: today)!, amount: 18000, type: .withdrawal, category: .food, memo: "저녁"),
            Transaction(date: calendar.date(byAdding: .day, value: -97, to: today)!, amount: 7800, type: .withdrawal, category: .tranportation, memo: "버스"),
            Transaction(date: calendar.date(byAdding: .day, value: -98, to: today)!, amount: 95000, type: .withdrawal, category: .shopping, memo: "선물"),
            Transaction(date: calendar.date(byAdding: .day, value: -99, to: today)!, amount: 75000, type: .deposit, category: .dividends, memo: "배당금"),
            Transaction(date: calendar.date(byAdding: .day, value: -100, to: today)!, amount: 150000, type: .deposit, category: .appRevenue, memo: "앱 인앱 결제 수익")
        ]
    }
}

struct BankingTradeAnalysis: View {
    @State private var displayMode: DisplayMode = .none
    let vm: TransactionViewModel = TransactionViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                ForEach(DisplayMode.allCases.dropFirst(), id: \.self) { mode in
                    Button(mode.rawValue) {
                        withAnimation(.spring) {
                            displayMode = mode
                        }
                    }
                }
            }
            
            switch displayMode {
            case .none:
                EmptyView()
            case .withdrawalOnly:
                WithDrawalView(vm: vm)
            case .formattedAmounts:
                OverOneThousandTransaction(vm: vm)
            case .totalExpenditureInMonth:
                TotalExpenditureView(vm: vm)
            case .transactionWithCategory:
                TransactionCategoryView(vm: vm)
            case .meanValueOfFoodExpenditure:
                MajorExpensesInFoodView(vm: vm)
            }
        }
    }
}

struct WithDrawalView: View {
    let vm: TransactionViewModel
    var body: some View {
        List {
            ForEach(vm.withdrawalOnly, id: \.id) { transaction in
                HStack {
                    Text(transaction.date.formatted(date: .numeric, time: .omitted))
                    Text("\(transaction.amount)원")
                    Text(transaction.type.rawValue)
                    Text(transaction.category?.rawValue ?? "용도 미상")
                    Text(transaction.memo ?? "지출처 미상")
                }
            }
        }
    }
}

struct OverOneThousandTransaction: View {
    let vm: TransactionViewModel
    var body: some View {
        List {
            ForEach(vm.formattedAmounts, id: \.self) { amount in
                Text("\(amount)원")
            }
        }
    }
}

struct TotalExpenditureView: View {
    let vm: TransactionViewModel
    var body: some View {
        VStack {
            Label("월간 총 지출액: \(vm.totalExpenditureInMonth)원", systemImage: "wonsign.bank.building.fill")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding(10)
                .padding(.horizontal, 10)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding()
        }
    }
}

struct TransactionCategoryView: View {
    let vm: TransactionViewModel
    var body: some View {
        List {
            ForEach(vm.transactionWithCategory, id: \.id) { transaction in
                HStack {
                    Text(transaction.date.formatted(date: .numeric, time: .omitted))
                    Text("\(transaction.amount)원")
                    Text(transaction.type.rawValue)
                    Text(transaction.category?.rawValue ?? "용도 미상")
                    Text(transaction.memo ?? "지출처 미상")
                }
            }
        }
    }
}

struct MajorExpensesInFoodView: View {
    let vm: TransactionViewModel
    var body: some View {
        Label("금액: \(vm.meanValueOfFoodExpenditure)원", systemImage: "fork.knife.circle.fill")
            .font(.title3)
            .fontWeight(.bold)
            .foregroundStyle(.pink)
    }
}

#Preview {
    BankingTradeAnalysis()
}

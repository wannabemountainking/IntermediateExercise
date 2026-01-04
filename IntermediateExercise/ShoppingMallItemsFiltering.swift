//
//  ShoppingMallItemsFiltering.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 1/8/26.
//

import SwiftUI
import Combine


struct Product: Identifiable {
    let id = UUID()
    let name: String
    let category: String
    var price: Int
    var inStock: Bool
    var discount: Int?
    
    var discountedPrice: Int {
        guard let discounted = discount else {return price}
        let doubledPrice = Double(price)
        let doubledDiscountedPrice = doubledPrice * (1.0 - Double(discounted))
        return Int(doubledDiscountedPrice)
    }
}

class ShoppingMallViewModel: ObservableObject {
    
    let products: [Product] = [
        Product(name: "iPhone 15", category: "Electronics", price: 1200, inStock: true, discount: 10),
        Product(name: "MacBook Pro", category: "Electronics", price: 2500, inStock: false, discount: 15),
        Product(name: "AirPods", category: "Electronics", price: 200, inStock: true, discount: nil),
        Product(name: "iPad Air", category: "Electronics", price: 800, inStock: true, discount: 12),
        Product(name: "Apple Watch", category: "Electronics", price: 450, inStock: false, discount: nil),
        Product(name: "무선키보드", category: "Electronics", price: 100, inStock: true, discount: 18),
        Product(name: "모니터", category: "Electronics", price: 350, inStock: true, discount: 10),
        Product(name: "청바지", category: "Clothing", price: 80, inStock: true, discount: nil),
        Product(name: "티셔츠", category: "Clothing", price: 30, inStock: true, discount: 30),
        Product(name: "재킷", category: "Clothing", price: 150, inStock: false, discount: 25),
        Product(name: "스니커즈", category: "Clothing", price: 120, inStock: true, discount: 15),
        Product(name: "후드티", category: "Clothing", price: 90, inStock: true, discount: 20),
        Product(name: "운동화", category: "Clothing", price: 180, inStock: true, discount: nil),
        Product(name: "모자", category: "Clothing", price: 25, inStock: true, discount: 40),
        Product(name: "사과(1kg)", category: "Food", price: 12, inStock: true, discount: 20),
        Product(name: "바나나(1kg)", category: "Food", price: 8, inStock: true, discount: nil),
        Product(name: "우유(1L)", category: "Food", price: 5, inStock: true, discount: 10),
        Product(name: "치킨(1마리)", category: "Food", price: 20, inStock: false, discount: 15),
        Product(name: "빵(10개)", category: "Food", price: 15, inStock: true, discount: 25),
        Product(name: "초콜릿(1박스)", category: "Food", price: 18, inStock: false, discount: nil)
    ]
    
    var discountedItemList: [Product] {
        products
            .filter { $0.discount != nil }
    }
    
    var ElectronicsInStock: [Product] {
        products
            .filter { $0.inStock }
    }
    
    var totalPriceInCart: Int {
        products.map { $0.discountedPrice }.reduce(0, +)
    }
    
    var clothingsWithReasonablePrice: [Product] {
        Array(
            products
                .filter { $0.inStock }
                .sorted { $0.discountedPrice <= $1.discountedPrice }
                .prefix(5)
        )
    }
}



struct ShoppingMallItemsFiltering: View {
    @StateObject private var vm: ShoppingMallViewModel = ShoppingMallViewModel()
    
    var body: some View {
        
        NavigationStack {
            TabView {
                Tab("할인", systemImage: "tag.fill") {
                    DiscountView(vm: vm)
                } // 할인 tab
            } //:TABVIEW
            .navigationTitle("상품 분석 앱")
            .navigationBarTitleDisplayMode(.inline)
            
        } //:NAVIGATION
    }//: body
}

struct DiscountView: View {
    let vm: ShoppingMallViewModel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.products, id: \.id) { product in
                    HStack {
                        Text(product.name)
                            .frame(width: 100)
                            .padding(.trailing, 15)
                        Text("$\(product.price)")
                            .frame(width: 60)
                            .padding(.trailing, 15)
                        Text(product.inStock ? "✓" : "재고없음")
                            .frame(width: 30)
                            .padding(.trailing, 15)
                        Text(product.discount != nil ? "\(product.discount!)% 할인" : "-")
                    } //:HSTACK
                } //:LOOP
            } //:LIST
        } //:NAVIGATION
    }//: body
}

#Preview {
    ShoppingMallItemsFiltering()
}

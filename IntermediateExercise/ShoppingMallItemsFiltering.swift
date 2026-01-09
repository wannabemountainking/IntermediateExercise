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
        let doubledDiscountedPrice = doubledPrice * (1.0 - (Double(discounted) / 100))
        return Int(doubledDiscountedPrice)
    }
}

class ShoppingMallViewModel: ObservableObject {
    
    @Published var itemsInCart: [Product] = []
    
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
    
    var electronicsInStock: [Product] {
        products
            .filter { $0.category == "Electronics" && $0.inStock }
    }
    
    var totalPriceInCart: Int {
        itemsInCart.map { $0.discountedPrice }.reduce(0, +)
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
    @State private var showTotalList: Bool = true
    @State private var isCurrentItemInCart: Bool = false
    
    var body: some View {
        
        NavigationStack {
            
            if showTotalList {
                MainView(
                    isCurrentItemInCart: $isCurrentItemInCart,
                    showTotalList: $showTotalList,
                    vm: vm
                )
            } else {
                TabView {
                    DiscountView(vm: vm)
                        .tabItem {
                            Label("할인", systemImage: "megaphone.fill")
                        }
                    
                    StockView(vm: vm)
                        .tabItem {
                            Label("재고", systemImage: "shippingbox.fill")
                        }
                    
                    PriceView(vm: vm)
                        .tabItem {
                            Label("가격", systemImage: "dollarsign")
                        }
                    
                    TotalPriceView(vm: vm)
                        .tabItem {
                            Label("총액", systemImage: "dollarsign.circle.fill")
                        }
                } //:TABVIEW
            }
        } //:NAVIGATION
    }//: body
}

struct MainView: View {
    @Binding var isCurrentItemInCart: Bool
    @Binding var showTotalList: Bool
    let vm: ShoppingMallViewModel
    
    var body: some View {
        
        List {
            ForEach(vm.products, id: \.id) { product in
                Button {
                    // action
                    if product.inStock {
                        isCurrentItemInCart.toggle()
                    }
                    if isCurrentItemInCart && product.inStock {
                        vm.itemsInCart.append(product)
                    } else {
                        vm.itemsInCart.removeAll(where: { $0.id == product.id })
                    }
                } label: {
                    HStack {
                        Text(product.name)
                            .frame(width: 75)
                            .padding(.trailing, 5)
                        Text("$\(product.price)")
                            .frame(width: 55)
                            .padding(.trailing, 5)
                        Text(product.category)
                            .frame(width: 85)
                            .padding(.trailing, 5)
                        Text(product.inStock ? "✓" : "재고없음")
                            .frame(width: 30)
                            .padding(.trailing, 5)
                        Text(product.discount != nil ? "\(product.discount!)% 할인" : "-")
                    } //:HSTACK
                    .foregroundStyle(vm.itemsInCart.contains(where: { $0.id == product.id }) ? .orange : .black)
                }
            } //:LOOP
        } //:LIST
        .navigationTitle("상품 분석 앱")
        .navigationBarTitleDisplayMode(.inline)
        
        Button("상품 선택") {
            showTotalList = false
        }
    }//:body
}

struct DiscountView: View {
    let vm: ShoppingMallViewModel
    
    var body: some View {
        List {
            Section {
                ForEach(vm.discountedItemList, id: \.id) { discountedItem in
                    HStack {
                        Text("\(discountedItem.discount!)%")
                            .frame(width: 50)
                            .padding(.trailing, 5)
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 50, height: 2)
                            .padding(.trailing, 15)
                        Text(discountedItem.name)
                    } //:HSTACK
                } //:LOOP
            } header: {
                Label("할인물품 목록", systemImage: "megaphone.fill")
                    .font(.title2)
            } footer: {
                Label("총 \(vm.discountedItemList.count)개 상품 할인 중", systemImage: "tag.fill")
                    .font(.headline)
            }//:SECTION
        } //:LIST
        .navigationTitle("할인 중인 상품")
        .navigationBarTitleDisplayMode(.inline)
    }//: body
}

struct StockView: View {
    let vm: ShoppingMallViewModel
    
    var body: some View {
        List {
            Section {
                //content
                ForEach(vm.electronicsInStock, id: \.id) { productInStock in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(productInStock.name)
                        HStack(spacing: 50) {
                            Text("$\(productInStock.price)")
                            if let discountedProduct = productInStock.discount {
                                Label("\(discountedProduct)% 할인", systemImage: "tag.fill")
                            }
                        } //:HSTACK
                        Text(productInStock.inStock ? "✅ 재고 있음" : "❎ 재고 없음")
                    } //:VSTACK
                } //:LOOP
            } header: {
                Label("재고 있는 전자제품", systemImage: "computermouse.fill")
                    .font(.title2)
            } footer: {
                Label("총 \(vm.electronicsInStock.count)개 상품", systemImage: "tag.fill")
                    .font(.headline)
            }//:SECTION
        } //:LIST
    }//: body
}

struct PriceView: View {
    let vm: ShoppingMallViewModel
    
    var body: some View {
        List {
            Section {
                // content
                ForEach(vm.products, id: \.id) { product in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 15) {
                            Text(product.name)
                                .frame(width: 120)
                            if product.inStock {
                                Text("❌ 품절")
                                    .frame(width: 150)
                            }
                        } //:HSTACK
                        HStack(spacing: 15) {
                            Text("$\(product.price)")
                                .frame(width: 90)
                            Image(systemName: "arrow.right")
                                .frame(width: 50)
                            Text("$\(product.discountedPrice)")
                                .frame(width: 90)
                            Text("💵")
                        } //:HSTACK
                    } //:VSTACK
                } //:LOOP
            } header: {
                Label("할인 적용 후 최종 가격", systemImage: "dollarsign")
                    .font(.title2)
            } footer: {
                Label("전체 \(vm.products.count)개 상품 가격 표시", systemImage: "tag.fill")
                    .font(.headline)
            }//:SECTION

        } //:LIST
    }
}

struct TotalPriceView: View {
    let vm: ShoppingMallViewModel
    
    var body: some View {
        List {
            Section {
                //content
                ForEach(vm.itemsInCart, id: \.id) { item in
                    HStack {
                        Text(item.name)
                            .frame(width: 120)
                        Text("$\(item.discountedPrice)")
                    }
                }
            } header: {
                Text("선택된 상품")
                    .font(.title2)
            } footer: {
                Label("최종 금액: $\(vm.totalPriceInCart)", systemImage: "dollarsign")
                    .font(.headline)
            }

            Button("💳 결제하기") {
                
            }
        }
        .navigationTitle("🛒 장바구니 총액 계산")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ShoppingMallItemsFiltering()
}

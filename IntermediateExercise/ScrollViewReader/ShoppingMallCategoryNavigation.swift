//
//  ShoppingMallCategoryNavigation.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 1/26/26.
//

import SwiftUI

enum Category: String, CaseIterable, Identifiable {
    case none = "없음"
    case clothing = "의류"
    case shoes = "신발"
    case bag = "가방"
    case accessory = "액세서리"
    
    var id: String {
        switch self {
        case .none: return "none"
        case .clothing: return "clothing"
        case .shoes: return "shoes"
        case .bag: return "bag"
        case .accessory: return "accessory"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .none: return Color.white
        case .clothing: return .red.opacity(0.5)
        case .shoes: return .yellow.opacity(0.5)
        case .bag: return .blue.opacity(0.5)
        case .accessory: return .indigo.opacity(0.5)
            
        }
    }
}

struct CategoryButton: View {
    let isTapped: Bool
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Spacer()
            Text(title)
                .font(.headline.bold())
                .frame(height: 50)
                .padding(.horizontal)
                .foregroundStyle(isTapped ? .white : .black)
                .background(isTapped ? Color.blue : .gray)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            Spacer()
        }

    }
}

struct ShoppingMallCategoryNavigation: View {
    
    @State private var categoryIndexScrollTo: Int = 0
    
    private var categories = Category.allCases.dropFirst()
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                ForEach(categories.indices, id: \.self) { categoryIndex in
                    CategoryButton(isTapped: categoryIndexScrollTo == categoryIndex, title: categories[categoryIndex].rawValue) {
                        categoryIndexScrollTo = categoryIndex
                    }
                }
            }
            
            ScrollView(.vertical) {
                ScrollViewReader { proxy in
                    ForEach(categories.indices, id: \.self) { categoryIndex in
                        LazyVStack(spacing: 0) {
                            Text(categories[categoryIndex].rawValue)
                                .font(.title2.bold())
                                .padding(.top, 20)
                            ForEach(1..<6) { itemIndex in
                                ZStack {
                                    Rectangle()
                                        .fill(Color.green.opacity(0.3))
                                        .frame(height: 120)
                                        .frame(maxWidth: .infinity)
                                        .background(categoryIndex == categoryIndexScrollTo ? Color.blue : .green.opacity(0.3))
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                        .padding(.horizontal, 15)
                                    Text("\(categories[categoryIndex].rawValue) #\(itemIndex)")
                                }
                                .padding(.vertical, 10)
                            }
                        }
                        .id(categoryIndex)
                        .background(categories[categoryIndex].backgroundColor)
                    }
                    .onChange(of: categoryIndexScrollTo) { _, newValue in
                        withAnimation(.spring()) {
                            proxy.scrollTo(newValue, anchor: .top)
                        }
                    }
                    
                }
            }
        }
    }
}

#Preview {
    ShoppingMallCategoryNavigation()
}

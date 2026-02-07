//
//  TapIndicator.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 2/6/26.
//

import SwiftUI


enum TabOfCategory: String, Identifiable, CaseIterable {
    case home = "홈"
    case search = "검색"
    case profile = "프로필"
    
    var id: Self { self }
}

struct TapIndicator: View {
    
    private let categories: [TabOfCategory] = TabOfCategory.allCases
    @State private var selectedTab: TabOfCategory = .home
    @Namespace private var itemIndicator
    
    var body: some View {
        ScrollView {
            HStack {
                ForEach(categories, id: \.id) { item in
                    ZStack {
                        if selectedTab.id == item.id {
                            Capsule()
                                .fill(Color.green)
                                .matchedGeometryEffect(id: "category", in: itemIndicator)
                                .frame(width: 40, height: 3)
                                .offset(y: 20)
                        }
                        
                        Text(item.rawValue)
                            .font(.title2)
                            .fontWeight(selectedTab.id == item.id ? .bold : .regular)
                    } //:ZSTACK
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            selectedTab = item
                        }
                    }
                } //:LOOP
            } //:HSTACK
            Spacer()
        } //:SCROLL
    }//:body
}

#Preview {
    TapIndicator()
}

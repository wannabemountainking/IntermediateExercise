//
//  LocalViewBuilderInter.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 2/4/26.
//

import SwiftUI

struct LocalViewBuilderInter: View {
    
    enum MenuType: String, Identifiable, CaseIterable {
        
        case home = "홈"
        case search = "검색"
        case settings = "설정"
        
        var id: Self { self }
        
        var image: String {
            switch self {
            case .home: return "house"
            case .search: return "magnifyingglass"
            case .settings: return "gear"
            }
        }
    }
    
    @State private var selectedMenu: MenuType = .home
    
    var body: some View {
        
        TabView(selection: $selectedMenu) {
            ForEach(MenuType.allCases) { menuType in
                Tab(value: menuType) {
                    //content
                    contentView(menuType: menuType)
                } label: {
                    labelView(menuType: menuType)
                }
            }
        }
        .tint(Color.blue)
        
    }
    
    @ViewBuilder
    private func contentView(menuType: MenuType) -> some View {
        VStack {
            Text("\(menuType.rawValue) 화면입니다")
                .font(.largeTitle)
                .fontWeight(.semibold)
        }
    }
    
    @ViewBuilder
    private func labelView(menuType: MenuType) -> some View {
        Label(menuType.rawValue, systemImage: menuType.image)
    }
}


#Preview {
    LocalViewBuilderInter()
}

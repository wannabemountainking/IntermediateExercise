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
        
        var id: String {
            switch self {
            case .home: return "home"
            case .search: return "search"
            case .settings: return "settings"
            }
        }
        
        var image: String {
            switch self {
            case .home: return "house"
            case .search: return "magnifyingglass"
            case .settings: return "gear"
            }
        }
        
        var text: String {
            switch self {
            case .home: "홈 화면입니다"
            case .search: "검색 화면입니다"
            case .settings: "설정 화면입니다"
            }
        }
    }
    
    @State private var selectedMenu: MenuType = .home
    @State private var isSelected: Bool = false
    
    var body: some View {
        
        TabView(selection: $selectedMenu) {
            ForEach(MenuType.allCases, id: \.id) { menuType in
                Tab(value: menuType) {
                    //content
                    contentView(menuType: menuType)
                } label: {
                    labelView(menuType: menuType)
                }
            }
        }
        
    }
    
    @ViewBuilder
    private func contentView(menuType: MenuType) -> some View {
        VStack {
            Text(menuType.text)
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

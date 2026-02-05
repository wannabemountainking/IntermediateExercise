//
//  TapIndicator.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 2/6/26.
//

import SwiftUI

struct TapIndicator: View {
    
    private let categories: [String] = ["홈", "검색", "프로필"]
    @State private var selectedItem: String = ""
    @Namespace private var itemIndicator
    
    var body: some View {
        VStack {
            HStack {
                ForEach(categories, id: \.self) { item in
                    ZStack {
                        Text(item)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
        }
    }
}

#Preview {
    TapIndicator()
}

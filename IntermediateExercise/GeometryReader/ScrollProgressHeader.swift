//
//  ScrollProgressHeader.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 1/28/26.
//

import SwiftUI


struct ProgressKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0.0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ScrollProgressHeader: View {
    
    
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ScrollProgressHeader()
}

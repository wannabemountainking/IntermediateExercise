//
//  CardStyleModifier.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 2/5/26.
//

import SwiftUI


struct CardStyleModifier: ViewModifier {
    let hasShadow: Bool
    let isRoundedShape: Bool
    let backgroundColor: Color
    let shadowRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(.title2.bold())
            .padding()
            .padding(.horizontal)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: isRoundedShape ? 10 : 0))
            .shadow(radius: hasShadow ? shadowRadius : 0)
            .padding()
    }
}

struct CardStyleViewModifier: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("일반 카드 (modifier 적용 전)")
                .font(.title)
            Text("일반카드용 텍스트 위치")
                .font(.title2.bold())
                .padding()
                .padding(.horizontal)
                .background(Color.gray.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 4)
                .padding()
            
            Divider()
            
            Text("CardStyle 카드 (modifier 적용 후)")
                .font(.title)
            Text("CardStyleCard")
                .modifier(CardStyleModifier(hasShadow: true, isRoundedShape: true, backgroundColor: Color.blue.opacity(0.5), shadowRadius: 5))
            
            Divider()
            
            Text("CardStyle extension 사용")
                .font(.title)
            Text("CardStyle Extension")
                .cardStyle(hasShadow: false, isRoundedShape: true, backgroundColor: Color.green.opacity(0.3), shadowRadius: 20)
        }
    }
}

extension View {
    func cardStyle(hasShadow: Bool, isRoundedShape: Bool, backgroundColor: Color, shadowRadius: CGFloat) -> some View {
        modifier(CardStyleModifier(hasShadow: hasShadow, isRoundedShape: isRoundedShape, backgroundColor: backgroundColor, shadowRadius: shadowRadius))
    }
}

#Preview {
    CardStyleViewModifier()
}

//
//  TitleTextViewModifier.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 2/5/26.
//

import SwiftUI

struct TitleTextStyleModifier: ViewModifier {
    
    let font: Font?
    let thickness: Font.Weight?
    let textColor: Color?
    let frameHeight: CGFloat?
    let frameWidth: CGFloat?
    let padding: CGFloat?
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .fontWeight(thickness)
            .foregroundStyle(textColor ?? .blue)
            .frame(height: frameHeight)
            .frame(maxWidth: frameWidth)
            .padding(padding ?? 0.0)
    }
}

struct TitleTextViewModifier: View {
    var body: some View {
        Text("제목입니다")
            .titleTextStyle(
                font: .largeTitle,
                thickness: .bold,
                textColor: Color.blue,
                frameHeight: 40,
                frameWidth: .infinity,
                padding: 20
            )
    }
}


extension View {
    func titleTextStyle(font: Font?, thickness: Font.Weight?, textColor: Color?, frameHeight: CGFloat?, frameWidth: CGFloat?, padding: CGFloat?) -> some View {
        modifier(TitleTextStyleModifier(font: font,
                                       thickness: thickness,
                                       textColor: textColor,
                                       frameHeight: frameHeight,
                                       frameWidth: frameWidth,
                                       padding: padding
                                      )
                        )
    }
}

#Preview {
    TitleTextViewModifier()
}

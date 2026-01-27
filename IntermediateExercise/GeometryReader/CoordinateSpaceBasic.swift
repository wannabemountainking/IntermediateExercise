//
//  CoordinateSpaceBasic.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 1/27/26.
//

import SwiftUI

struct ScrollOffsetKey: PreferenceKey {
    // 1. 어떤 타입의 데이터를 보낼 것인가
    typealias Value = CGFloat
    // 2. 초기값(아무것도 안보냈을때)
    static var defaultValue: CGFloat = 0
    // 3. 여러 값이 오면 어떻게 합칠 지 -> 여기서는 그냥 바뀐 새로운 값으로 바꾼다는 뜻. 위치파악시..
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct CoordinateSpaceBasic: View {
    @State private var coordinateY: CGFloat = 0.0
    let randomColors: [Color] = [.red, .green, .yellow, .blue, .orange, .pink, .cyan, .brown, .indigo, .purple, .gray, .mint, .red, .green, .yellow, .blue, .orange, .pink, .cyan, .brown, .indigo, .purple]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("스크롤 위치: \(Int(coordinateY))")
                .font(.title)
            ScrollView(.vertical) {
                ZStack {
                    Rectangle()
                        .fill(randomColors[0])
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .background(
                            GeometryReader { proxy in
                                Color.clear
                                    .preference(key: ScrollOffsetKey.self, value: proxy.frame(in: .named("scrollView")).minY)
//                                    .onChange(of: proxy.frame(in: .named("scrollView"))) { oldValue, newValue in
//                                        coordinateY = newValue.minY
//                                    }
                            }
                        )
                    Text("📱 아이템 1")
                        .font(.title2)
                }
                ForEach(2..<21) { index in
                    ZStack {
                        Rectangle()
                            .fill(randomColors[index - 1])
                            .frame(height: 100)
                            .frame(maxWidth: .infinity)
                        Text("📱 아이템 \(index)")
                            .font(.title2)
                    }
                } //:LOOP
            } //:SCROLL
            .coordinateSpace(name: "scrollView")
            .onPreferenceChange(ScrollOffsetKey.self) { newValue in
                coordinateY = newValue
            }
        }//: VStack
        .padding(20)
    }//:body
}

#Preview {
    CoordinateSpaceBasic()
}

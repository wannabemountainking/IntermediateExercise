//
//  PreferenceKeyInter.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 1/28/26.
//

import SwiftUI


struct DynamicTextviewHeight: PreferenceKey {
    
    typealias Value = CGFloat
    
    static var defaultValue: CGFloat = 0.0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct PreferenceKeyInter: View {
    
    @State private var texts: [String] = []
    @State private var subViewHeight: CGFloat = 0.0
    private let newTexts: [String] = [
        "안녕",
        "iOS 개발 재미있어요!",
        "SwiftUI는 선언형 프레임워크입니다.",
        "GeometryReader를 사용하면 자식 뷰의 크기를 측정할 수 있어요.",
        "오늘은 날씨가 정말 좋네요. 산책하기 딱 좋은 날입니다.",
        "Swift 언어는 안전성과 성능을 모두 고려해서 설계되었습니다. 옵셔널과 타입 안정성이 그 예시죠.",
        "박물관 큐레이터로 일하면서 다양한 예술 작품들을 접할 수 있었습니다. 특히 중국 회문 텍스트를 처리하는 프로젝트가 흥미로웠어요.",
        "한 줄",
        "PreferenceKey 프로토콜을 구현하면 자식 뷰에서 부모 뷰로 데이터를 전달할 수 있습니다. 이는 SwiftUI의 데이터 흐름에서 상향식 통신을 가능하게 합니다.",
        "Python으로 OpenCV를 활용한 자동화 프로그램을 만들었을 때의 경험이 지금 iOS 개발을 공부하는 데도 도움이 되고 있습니다. 프로그래밍의 기본 로직은 언어가 달라도 비슷하니까요."
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("총 높이: \(Int(subViewHeight))")
                .font(.largeTitle)
                .fontWeight(.ultraLight)
            Divider()
            
            Button {
                //action
                let newText = newTexts[Int.random(in: 0...newTexts.count - 1)]
                texts.append(newText)
            } label: {
                Text("텍스트 추가 버튼")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .padding(10)
                    .padding(.horizontal, 20)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            Divider()
            
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    ForEach(texts, id: \.self) { text in
                        Text(text)
                            .font(.title3)
                            .fontWeight(.ultraLight)
                    }
                } //:VSTACK
                .overlay(
                    GeometryReader(content: { proxy in
                        let topNotch = proxy.frame(in: .named("vStack")).minY
                        let bottom = proxy.frame(in: .named("vStack")).maxY
                        Color.clear
                            .preference(key: DynamicTextviewHeight.self, value: abs(topNotch - bottom))
                    })
                )
                .coordinateSpace(.named("vStack"))
            } //:SCROLL
            .onPreferenceChange(DynamicTextviewHeight.self) { height in
                print(height)
                subViewHeight = height
            }
        } //:VSTACK
        .padding(25)
    }//:body
}

#Preview {
    PreferenceKeyInter()
}

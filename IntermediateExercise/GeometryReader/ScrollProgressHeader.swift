//
//  ScrollProgressHeader.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 1/28/26.
//

import SwiftUI


struct ScreenHeightKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0.0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ScrollItemOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0.0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ProgressOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0.0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ScrollProgressHeader: View {
    
    @State private var coordinateY: CGFloat = 0
    @State private var headerProgressWidth: CGFloat = 0.0
    @State private var visibleScrollViewHeight: CGFloat = 600 // proxy.size.height - 60
    
    private let scrollViewHeight: CGFloat = 10 * 200
    private var praticalScrollViewHeight: CGFloat {
        scrollViewHeight - visibleScrollViewHeight
    }
    private var progressRate: Int {
        let ratio = 1 - abs(coordinateY) / praticalScrollViewHeight
        let result = Int(ratio * 90 + 5)
        switch result {
        case ..<5: return 5
        case 5...95: return result
        case 96...: return 95
        default: return 0
        }
    }
    
    
    private var headerHeight: CGFloat {
        switch progressRate {
        case 30...95:
            return 60.0 + ((CGFloat(progressRate) - 30.0) / 65.0) * 140.0
        case 5..<30:
            return 60.0
        default:
            return 0.0
        }
    }
    private var headerBackgroundColor: Color {
        switch progressRate {
        case 66...95: return Color.green
        case 33..<66: return Color.orange
        case 5..<33: return Color.red
        default: return Color.white
        }
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            GeometryReader { outerProxy in
                
                VStack(alignment: .leading) {
                    HStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(headerBackgroundColor)
                            .frame(height: 20)
                            .frame(width: outerProxy.size.width * CGFloat(progressRate - 5) / 90.0 - 80)
                        Text("\(progressRate)%")
                            .frame(minWidth: 50)
                    } //:HSTACK
                    .safeAreaPadding(.horizontal)
                    
                    switch progressRate {
                        case 66...95:
                            VStack {
                                Text("My Amazing Header")
                                Text("Scroll to see magic ✨")
                            }
                            .safeAreaPadding(.horizontal)
                        case 33..<66:
                            Text("Header")
                            .safeAreaPadding(.horizontal)
                        default:
                            Text("")
                                .frame(height: 0.0)
                                .safeAreaPadding()
                    }
                } //:VStack
            } //:GEOMETRY
            .frame(height: headerHeight)
                
            ScrollView(.vertical) {
                
                Text("Content Item 1")
                    .font(.title.bold())
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .overlay(
                        GeometryReader(content: { firstscrollItemProxy in
                            Color.clear
                                .preference(key: ScrollItemOffsetKey.self, value: firstscrollItemProxy.frame(in: .named("scrollFirst")).minY)
                        })
                    )
                
                ForEach(2..<11, id: \.self) { number in
                    Text("Content Item \(number)")
                        .font(.title.bold())
                        .frame(height: 200)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
            } //:SCROLL
            .coordinateSpace(.named("scrollFirst"))
            
            .onPreferenceChange(ScrollItemOffsetKey.self) { firstItem in
                coordinateY = firstItem
            }
            .overlay (
                GeometryReader(content: { screenHeightProxy in
                    let screenHeight = screenHeightProxy.size.height - 60
                    Color.clear
                        .preference(key: ScreenHeightKey.self, value: screenHeight)
                })
            )
            .onPreferenceChange(ScreenHeightKey.self) { height in
                visibleScrollViewHeight = height
            }
        } //:VSTACK
    }// :body
}

#Preview {
    ScrollProgressHeader()
}

//
//  DragCard.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 1/31/26.
//

import SwiftUI


struct DragCard: View {
    
    @State private var offset: CGSize = .zero
    
    private var distance: CGFloat {
        sqrt(pow(offset.width, 2) + pow(offset.height, 2) - 150)
    }
    
    var body: some View {
        
        ZStack {
            Color.gray.opacity(0.3)
                .ignoresSafeArea()
            GeometryReader { geoProxy in

                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Gradient(colors: [Color.blue.opacity(0.5), .blue.opacity(0.9)]))
                            .frame(width: 200, height: 300)
                            .shadow(radius: 10, x: 20, y: 20)
                        
                        Text("CARD")
                            .font(.title.bold())
                            .foregroundStyle(.white)
                    } //:ZSTACK
                    .frame(width: geoProxy.size.width, height: geoProxy.size.height, alignment: .center)
                    .offset(offset)
                    .scaleEffect(getScaleAmount(proxy: geoProxy))
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                withAnimation(.spring()) {
                                    offset = value.translation
                                }
                            })
                            .onEnded({ value in
                                withAnimation(.spring()) {
                                    offset = .zero
                                }
                            })
                    )
            } //:GEOMETRY
        } //:ZSTACK
    }//:body
    
    private func getScaleAmount(proxy: GeometryProxy) -> CGFloat {
        let maxWidth = proxy.size.width / 2
        let maxHeight = proxy.size.height / 2
        let maxDistance = sqrt(maxWidth * maxWidth + maxHeight * maxHeight)
        let currentAmount = sqrt(pow(offset.width, 2) + pow(offset.height, 2))
        let ratio = currentAmount / maxDistance
        return (currentAmount <= 200) ? 1 - ratio : 0.7
    }
}

#Preview {
    DragCard()
}

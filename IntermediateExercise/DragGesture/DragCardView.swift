//
//  DragCardView.swift
//  IntermediateExercise
//
//  Created by yoonie on 1/31/26.
//

import SwiftUI

struct DragCardView: View {
    
    @State private var offset: CGSize = .zero
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.3)
                .ignoresSafeArea()
            VStack(alignment: .center, spacing: 100) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Gradient(colors: [Color.blue.opacity(0.5), .blue.opacity(0.9)]))
                        .frame(width: 200, height: 300)
                        .shadow(radius: 20, x: 20, y: 20)
                        .offset(offset)
                        .scaleEffect(getScaleAmount())
                        .gesture(
                            DragGesture()
                            
                        )
                    Text("Card")
                        .font(.title.bold())
                        .foregroundStyle(.white)
                }
                Text("Drag me!")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
            }
        }
    }
    
    private func calculateDistance(x: CGFloat, y: CGFloat) -> CGFloat {
        return sqrt(x * x + y * y)
    }
    private func getScaleAmount(x: CGFloat, y: CGFloat) -> CGFloat {
        let maxDistance = sqrt(pow(UIScreen.main.bounds.width / 2, 2) + pow(UIScreen.main.bounds.height / 2, 2))
        let currentDistance = calculateDistance(x: x, y: y)
        let percentage = 1 / currentDistance * maxDistance
        return 1.0 - percentage
    }
}

#Preview {
    DragCardView()
}

//
//  FlexibleProfileCard.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 2/6/26.
//

import SwiftUI


struct ProfileCard: View {
    
    var hasEnlarged: Bool
    
    init(hasEnlarged: Bool) {
        self.hasEnlarged = hasEnlarged
    }
    
    var body: some View {
        Image(systemName: "person")
            .resizable()
            .foregroundStyle(.red)
            .padding(5)
            .frame(width: hasEnlarged ? 150 : 50, height: hasEnlarged ? 150 : 50)
            .background(
                Circle()
                    .fill(Color.gray.opacity(0.2))
            )
            .clipShape(Circle())
    }
}

struct FlexibleProfileCard: View {
    
    @State private var hasEnlarged: Bool = false
    @Namespace private var namespace
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                if !hasEnlarged {
                    ProfileCard(hasEnlarged: hasEnlarged)
                        .matchedGeometryEffect(id: "person", in: namespace)
                } else {
                    ProfileCard(hasEnlarged: hasEnlarged)
                        .matchedGeometryEffect(id: "person", in: namespace)
                }
                Text("김철수")
                if hasEnlarged {Text("iOS Developer")}
            } //:VSTACK
            .onTapGesture {
                withAnimation(.spring()) {
                    hasEnlarged.toggle()
                }
            }
        }
    }//:body
}

#Preview {
    FlexibleProfileCard()
}

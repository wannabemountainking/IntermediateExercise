//
//  CoordinateSpaceBasic.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 1/27/26.
//

import SwiftUI

struct CoordinateSpaceBasic: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            GeometryReader { proxy in
                let coordinateY = proxy.frame(in: .global)
                HStack(spacing: 5) {
                    Text("스크롤 위치:")
                    Text("\()")
                }
                .font(.title2.bold())
            }

        }
    }
}

#Preview {
    CoordinateSpaceBasic()
}

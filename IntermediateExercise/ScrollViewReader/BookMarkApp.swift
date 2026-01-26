//
//  BookMarkApp.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 1/26/26.
//

import SwiftUI


struct UpButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.headline.bold())
                .padding(7)
                .padding(.horizontal, 10)
                .foregroundStyle(.white)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(10)
        }
    }
}

struct BookMarkApp: View {
    @State private var indexScrollTo: Int = 0
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                UpButton(title: "처음으로") {
                    indexScrollTo = 1
                }
                UpButton(title: "중간으로") {
                    indexScrollTo = 25
                }
                UpButton(title: "끝으로") {
                    indexScrollTo = 50
                }
            } //:HSTACK
            
            ScrollView(.vertical) {
                ScrollViewReader { proxy in
                    ForEach(1..<51) { index in
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.green.opacity(0.3))
                                .frame(height: 150)
                                .frame(maxWidth: .infinity)
                                .shadow(radius: 5, x: 7, y: 7)
                                .padding(.horizontal, 20)
                            
                            Text("책 #\(index)")
                                .font(.title3.bold())
                        } //:ZSTACK
                        .id(index)
                    } //:LOOP
                    .onChange(of: indexScrollTo) { oldValue, newValue in
                        withAnimation(.spring()) {
                            proxy.scrollTo(newValue)
                        }
                    }
                } //:SCROLLVIEWREADER
            } //:SCROLL
        } //:VSTACK
    }//: body
}

#Preview {
    BookMarkApp()
}

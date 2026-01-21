//
//  SwiftUIView.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 1/24/26.
//

import SwiftUI


struct CardView<Content: View>: View {
    var title: String
    var content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(title)
                .font(.title)
                .fontWeight(.semibold)
            
            Rectangle()
                .fill(Color(uiColor: UIColor.magenta).opacity(0.7))
                .frame(width: .infinity, height: 1)

            content

        }
        .padding(30)
        .frame(width: 340, height: 300)
        .foregroundStyle(.white)
        .background(Color.teal.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}


struct GenericCardView: View {

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    CardView(title: "Text Card") {
                        Text("안녕하세요!")
                        Text("제네릭 카드입니다.")
                    }
                    
                    CardView(title: "Image Card") {
                        Image(systemName: "photo.fill")
                            .resizable()
                            .scaledToFit()
                    }
                    
                    CardView(title: "List Card") {
                        ForEach(1..<4) { number in
                            Text("Item \(number)")
                                .listRowBackground(Color.clear)
                        }
                    }
                }
            }
            .navigationTitle("Card Gallery")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    GenericCardView()
}

//
//  UIActivityIndicatorView.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 2/7/26.
//

import SwiftUI


struct UIIndicatorViewRepresentable: UIViewRepresentable {
    
    @Binding var isAnimating: Bool
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(frame: .zero)
        activityIndicator.style = .large
        activityIndicator.color = .systemGreen
        return activityIndicator
    }
    
    func updateUIView(_ acitivityIndicator: UIActivityIndicatorView, context: Context) {
        isAnimating ? acitivityIndicator.startAnimating() : acitivityIndicator.stopAnimating()
    }
    
}

struct ActivityIndicator: View {
    
    @State private var isAnimating: Bool = false
    
    var body: some View {
        VStack(spacing: 30) {
            UIIndicatorViewRepresentable(isAnimating: $isAnimating)
            
            Button("Start Loading") {
                isAnimating = true
            }
            .buttonModifier()
            
            Button("Stop Loading") {
                isAnimating = false
            }
            .buttonModifier()
        }
    }
}

struct LoadingButtonModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .padding(10)
            .padding(.horizontal)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension View {
    func buttonModifier() -> some View {
        modifier(LoadingButtonModifier())
    }
}

#Preview {
    ActivityIndicator()
}

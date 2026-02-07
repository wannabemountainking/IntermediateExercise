//
//  UISliderWrapping.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 2/7/26.
//

import SwiftUI


struct UISliderViewRepresentable: UIViewRepresentable {
    @Binding var sliderValue: Double
    
    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = Float(sliderValue)
        slider.tintColor = .systemBlue
        slider.addTarget(
            context.coordinator,
            action: #selector(context.coordinator.sliderValueChanged(_:)),
            for: .valueChanged
        )
        return slider
    }
    
    func updateUIView(_ slider: UISlider, context: Context) {
        if slider.value != Float(sliderValue) {
            slider.setValue(Float(sliderValue), animated: true)
        }
    }
    
    func makeCoordinator() -> UISliderViewCoordinator {
        return UISliderViewCoordinator(sliderValue: $sliderValue)
    }
    
    class UISliderViewCoordinator: NSObject {
        @Binding var sliderValue: Double
        
        init(sliderValue: Binding<Double>) {
            self._sliderValue = sliderValue
        }
        
        @objc func sliderValueChanged(_ sender: UISlider) {
            sliderValue = Double(sender.value)
        }
    }
    
}

struct UISliderWrapping: View {
    
    @State private var sliderValue: Double = 55.0
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("현재 값: \(sliderValue.formatted(.number.precision(.fractionLength(1))))")
            
            VStack(alignment: .leading) {
                Text("SwiftUI Slider")
                Slider(value: $sliderValue, in: 0.0...100.0)
            }
            
            VStack(alignment: .leading) {
                Text("UIKit Slider")
                UISliderViewRepresentable(sliderValue: $sliderValue)
            }
        } //:VSTACK
        .padding(20)
    }
}

#Preview {
    UISliderWrapping()
}

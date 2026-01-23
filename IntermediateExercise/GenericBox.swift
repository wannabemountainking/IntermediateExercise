//
//  GenericBox.swift
//  IntermediateExercise
//
//  Created by yoonie on 1/23/26.
//

import SwiftUI
import Combine


struct Box<T> {
    var value: T
    var description: String {
        "Box contains \(value)"
    }
    
    mutating func updateValue(_ newValue: T) {
        self.value = newValue
    }
}

struct GenericBox: View {
    
    @State private var integerBox: Box<Int> = Box(value: 42)
    @State private var stringBox: Box<String> = Box(value: "Hello")
    @State private var boolBox: Box<Bool> = Box(value: true)
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 40) {
                VStack(alignment: .leading) {
                    Text("Integer Box: \(integerBox.description)")
                    Text("String Box: \(stringBox.description)")
                    Text("Bool Box: \(boolBox.description)")
                }
                
                Button("값 변경 버튼") {
                    integerBox.updateValue(Int.random(in: 0...200))
                    stringBox.updateValue(["iOS", "Swift", "Apple"].randomElement()!)
                    boolBox.updateValue(!boolBox.value)
                }
            }
            .navigationTitle("Generic Box Demo")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    GenericBox()
}

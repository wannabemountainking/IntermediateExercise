//
//  GenericSwapFunction.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 1/24/26.
//

import SwiftUI
import Combine


class SwapFunctionViewModel<T>: ObservableObject {
    @Published var first: T
    @Published var second: T
    
    init(first: T, second: T) {
        self.first = first
        self.second = second
    }
    

}


struct GenericSwapFunction<T>: View {
    private let originalFirst: T
    private let originalSecond: T
    @State private var first: T
    @State private var second: T
    @State private var showResult: Bool = false
    
    init(first: T, second: T) {
        self.first = first
        self.second = second
        self.originalFirst = first
        self.originalSecond = second
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Text("Before Swap")
                Text("first = \(String(describing: originalFirst))")
                Text("second = \(String(describing: originalSecond))")
            }
            .navigationTitle("Swap Demo")
            .navigationBarTitleDisplayMode(.inline)
            
            Button("Swap Numbers") {
                swapValue(a: &first, b: &second)
                showResult = true
            }
            if showResult {
                Form {
                    Text("After Swap")
                    Text("first = \(String(describing: first))")
                    Text("second = \(String(describing: second))")
                }
            }
        }
    }
    
    func swapValue(a: inout T, b: inout T) {
        let temp = b
        b = a
        a = temp
    }
}

#Preview {
    GenericSwapFunction(first: "Banana", second: "Apple")
}

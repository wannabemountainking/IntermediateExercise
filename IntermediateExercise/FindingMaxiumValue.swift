//
//  FindingMaxiumValue.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 1/24/26.
//

import SwiftUI
import Combine


struct FindingMaxiumValue<T: Comparable>: View {
    @State private var values: [T]
    
    private var max: String {
        guard let maxValue = findMaxValue(arr: values) else {return "최대값 없음"}
        return "\(maxValue)"
    }
    
    init(values: [T]) {
        self.values = values
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Text(verbatim: "Values = \(values)")
                Text("Max : \(max)")
            }
        }
    }
    
    private func findMaxValue(arr: [T]) -> T? {
        guard !arr.isEmpty else { return nil }
        var maxValue = arr[0]
        for item in arr.dropFirst() {
            if item > maxValue {
                maxValue = item
            }
        }
        return maxValue
    }
}

#Preview {
    FindingMaxiumValue(values: ["apple", "zebra", "banana"] )
}

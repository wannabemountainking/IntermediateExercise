//
//  SimpleTimerAlarm.swift
//  IntermediateExercise
//
//  Created by yoonie on 2/1/26.
//

import SwiftUI




struct SimpleTimerAlarm: View {
    @State private var selectedTime: Int = 5
    
    private let timeIntervals: [Int] = [5, 10, 30, 60]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("타이머 알림 앱")
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            Divider()
            
            ForEach(0..<timeIntervals.count, id: \.self) { index in
                Button {
                    //action
                    selectedTime = timeIntervals[index]
                } label: {
                    Text("\(timeIntervals[index])초      \()")
                }

            }


        }
        .padding(50)
    }
}

#Preview {
    SimpleTimerAlarm()
}

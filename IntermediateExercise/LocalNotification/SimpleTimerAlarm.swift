//
//  SimpleTimerAlarm.swift
//  IntermediateExercise
//
//  Created by yoonie on 2/1/26.
//

import SwiftUI

<<<<<<< HEAD

=======
struct Contents: Identifiable {
    let id = UUID()
    var title: String
    var content: String {
        let seconds = title.components(separatedBy: "초")[0]
        return "\(seconds)초가 지났습니다"
    }
}

struct AlarmTimer: Identifiable {
    let id = UUID()
    let title: String
    var contents: Contents {
        Contents(title: title)
    }
    
    var designatedTime: Double {
        guard let time = Double(title.components(separatedBy: "초")[0]) else { return 0.0 }
        return time
    }
    
    func startTimer() {
        DispatchQueue.global().asyncAfter(deadline: .now() + designatedTime) {
            DispatchQueue.main.async {
                <#code#>
            }
        }
    }
}
>>>>>>> origin/main


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
<<<<<<< HEAD
                    Text("\(timeIntervals[index])초      \()")
=======
//                    Text("\(timeIntervals[index])초      \()")
>>>>>>> origin/main
                }

            }


        }
        .padding(50)
    }
}

#Preview {
    SimpleTimerAlarm()
}

//
//  SimpleTimerAlarm.swift
//  IntermediateExercise
//
//  Created by yoonie on 2/1/26.
//

import SwiftUI
import Combine
import UserNotifications


enum TimerPreset: String, Identifiable, CaseIterable {
    case none = "타이머 선택 안함"
    case short = "5초"
    case medium = "10초"
    case long = "30초"
    case veryLong = "60초"
    
    var id: Double {
        switch self {
        case .none: return 0
        case .short: return 5
        case .medium: return 10
        case .long: return 30
        case .veryLong: return 60
        }
    }
}

class NotificationManager {
    static let shared: NotificationManager = NotificationManager()
    private init() {}
    
    // 1. 권한 요청
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(with: options) { (hasAuthorized, error) in
            if let error {
                print("에러: \(error)")
            } else {
                print("성공")
            }
        }
    }
    
}

class SimpleTimerViewModel: ObservableObject {
    @Published var timerSelected: TimerPreset = .none
    
    let timers: [CustomTimer] = TimerPreset.allCases.dropFirst()
    
    //
}

struct SimpleTimerAlarm: View {
    @StateObject private var vm: SimpleTimerViewModel = SimpleTimerViewModel()
    
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
                    Text("\(timeIntervals[index])초")
                }
            }
        }
        .padding(50)
    }
}

#Preview {
    SimpleTimerAlarm()
}

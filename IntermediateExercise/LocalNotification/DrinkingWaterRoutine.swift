//
//  DrinkingWaterRoutine.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 2/2/26.
//

import SwiftUI
import Combine
import UserNotifications


enum IntervalType: String, Identifiable, CaseIterable {
    case none = "선택 안 함"
    case short = "30분마다"
    case medium = "1시간마다"
    case long = "2시간마다"
    
    var id: Double {
        switch self {
        case .none: return 0
        case .short: return 1800
        case .medium: return 3600
        case .long: return 7200
        }
    }
}

struct WaterPreset: Identifiable {
    let id = UUID()
    let type: IntervalType
    var isSelected: Bool
}

class MyNotificationManager {
    static let shared = MyNotificationManager()
    private init() { }
    
    // TODO: 알림 권한 신청(onAppear에서 해결)
    func requestAuthorization() {
        let authOptions: UNAuthorizationOptions = [.alert, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (success, error) in
            if let error {
                print("에러: \(error)")
            } else {
                print("성공")
            }
        }
    }
    
    // TODO: 시간 마다 반복되는 알림 설정
    func scheduleRepeatingNotification(waterInterval: WaterPreset) {
        let content = UNMutableNotificationContent()
        content.title = "💧 물 마실 시간"
        content.body = "건강을 위해 물을 마셔주세요!"
        content.sound = .default
        
        let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: waterInterval.type.id, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "water_reminder",
            content: content,
            trigger: timeTrigger
        )
        UNUserNotificationCenter.current().add(request)
    }
    
    // TODO: 알림 취소
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}

class WaterIntervalViewModel: ObservableObject {
    @Published var selectedPreset: WaterPreset = WaterPreset(type: .none, isSelected: false)
    @Published var isAlarmActive: Bool = false
    var intervals: [WaterPreset] = Array(IntervalType.allCases.dropFirst())
        .map { WaterPreset(type: $0, isSelected: false) }
}

struct DrinkingWaterRoutine: View {
    
    @StateObject private var vm = WaterIntervalViewModel()
    
    var statusText: String {
        if vm.isAlarmActive {
            return "📊  알림 커짐 (\(vm.selectedPreset.type.rawValue))"
        } else {
            return "📊  알림 꺼짐"
        }
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Text("💧 물 마시기 알람 앱")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Section {
                // content
                //TODO: 간격버튼 3개
                VStack(spacing: 15) {
                    ForEach(0..<vm.intervals.count, id: \.self) { index in
                        Button {
                            //action
                            for i in vm.intervals.indices {
                                vm.intervals[i].isSelected = (index == i)
                            }
                            vm.selectedPreset = vm.intervals[index]
                        } label: {
                            HStack {
                                Text(vm.intervals[index].type.rawValue)
                                Spacer()
                                if vm.intervals[index].isSelected {
                                    Text("✓")
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .padding(.horizontal, 20)
                            .foregroundStyle(vm.intervals[index].isSelected ? .white : .black)
                            .background(vm.intervals[index].isSelected ? .blue : .gray)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
            } header: {
                //TODO: 섹션 타이틀
                HStack {
                    Text("알림 간격 선택")
                        .font(.title2)
                    Spacer()
                } //:HSTACK
            }//:SECTION
            
            //TODO: 알림 시작 버튼
            Button("알림 시작하기") {
                guard vm.selectedPreset.type != .none else {return}
                vm.isAlarmActive = true
                MyNotificationManager.shared.scheduleRepeatingNotification(waterInterval: vm.selectedPreset)
            }
            .font(.title3.bold())
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(Color.green.opacity(vm.selectedPreset.type == .none || vm.isAlarmActive == true ? 0.5 : 1.0))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .disabled(vm.selectedPreset.type == .none || vm.isAlarmActive == true)
            
            //TODO: 알림 중지 버튼
            Button("알림 중지하기") {
                vm.isAlarmActive = false
                MyNotificationManager.shared.cancelAllNotifications()
            }
            .font(.title3.bold())
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(Color.red.opacity(vm.selectedPreset.type == .none || vm.isAlarmActive == false ? 0.5 : 1.0))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .disabled(vm.selectedPreset.type == .none || vm.isAlarmActive == false)

            //TODO: 상태 라벨
            if vm.selectedPreset.type != .none {
                Text(statusText)
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(15)
            }
            
        } //:VSTACK
        .padding(20)
        .onAppear {
            MyNotificationManager.shared.requestAuthorization()
        }
    }//:body
}

#Preview {
    DrinkingWaterRoutine()
}

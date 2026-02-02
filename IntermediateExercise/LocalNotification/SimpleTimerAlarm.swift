//
//  SimpleTimerAlarm.swift
//  IntermediateExercise
//
//  Created by yoonie on 2/1/26.
//

import SwiftUI
import Combine
import UserNotifications



enum TimerType: String, Identifiable, CaseIterable {
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

struct TimerPreset: Identifiable {
    let id = UUID()
    let type: TimerType
    var isSelected: Bool
}

// 1. 싱글톤, 2. noti 권한 요청, 3. 요청 내용, 4. noti로 요청서 작성(1. 시간 단위 trigger, 2. 날짜단위 trigger), 5. 요청 목록에 등록
class NotiManager {
    static let shared = NotiManager()
    private init() {}
    
    func requestNotificationAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error {
                print("에러: \(error.localizedDescription)")
            } else {
                print("성공")
            }
        }
    }

    func timeNotification(type: TimerType) {
        let content = UNMutableNotificationContent()
        content.title = "타이머 완료"
        content.sound = .default
        content.subtitle = "\(type.rawValue)가 지났습니다"
        
        let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: type.id, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: timeTrigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func getPendingNotification(completion: @escaping (Int) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { pendings in
            let count = pendings.count
            DispatchQueue.main.async {
                
                if #available(iOS 16.0, *) {
                    UNUserNotificationCenter.current().setBadgeCount(count)
                } else {
                    UIApplication.shared.applicationIconBadgeNumber = count
                }
                
                completion(pendings.count)
            }
        }
    }
    
    func cancelNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        if #available(iOS 16.0, *) {
            UNUserNotificationCenter.current().setBadgeCount(0)
        } else {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
}

class SimpleTimerViewModel: ObservableObject {
    
    @Published var timers: [TimerPreset] = Array(TimerType.allCases.dropFirst())
        .map { TimerPreset(type: $0, isSelected: false) }
    @Published var pendingCount: Int = 0
}

struct SimpleTimerAlarm: View {
    
    @StateObject private var vm: SimpleTimerViewModel = SimpleTimerViewModel()
    @State private var timerType: TimerType = .none
    @Environment(\.scenePhase) var scenePhage
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 60) {
            Text("타이머 알림 앱")
                .font(.title)
                .fontWeight(.semibold)
            
            Divider()

            VStack(spacing: 20) {
                ForEach(vm.timers.indices, id: \.self) { index in
                    Button {
                        //action
                        // TODO: 클릭 된 타이머의 속성 isSelected 를 true 로 하고 나머지는 모두 false로 변경
                        timerType = vm.timers[index].type
                        for i in vm.timers.indices {
                            vm.timers[i].isSelected = (i == index)
                        }
                        
                    } label: {
                        HStack(spacing: 30) {
                            Text(vm.timers[index].type.rawValue)
                                .font(.title3.bold())
                                .foregroundStyle(vm.timers[index].isSelected ? .white : .black)
                            if vm.timers[index].isSelected {
                                Text("선택됨")
                                    .font(.headline.bold())
                                    .foregroundStyle(.white)
                            }
                            Spacer()
                        }
                        .frame(height: 30)
                        .frame(maxWidth: .infinity)
                        .padding(5)
                        .padding(.horizontal)
                        .background(vm.timers[index].isSelected ? .blue : .gray)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                } //:LOOP
            }
            
            Button {
                //action
                // TODO: 클릭 시 선택된 시간에 알림 발송
                guard timerType != .none else {return}
                NotiManager.shared.timeNotification(type: timerType)
                NotiManager.shared.getPendingNotification { count in
                    vm.pendingCount = count
                }
            } label: {
                Text("타이머 시작")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(height: 45)
                    .frame(maxWidth: .infinity)
                    .padding(5)
                    .padding(.horizontal)
                    .background(Color.green)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            //TODO: badge 갯수 출력
            Label("현재 대기 중인 알림: \(vm.pendingCount)", systemImage: "alarm")
                .font(.title2)
            
            Button("모두 취소") {
                // TODO: 모든 알림 취소 코드
                NotiManager.shared.cancelNotification()
                NotiManager.shared.getPendingNotification { count in
                    vm.pendingCount = count
                }
            }
            .font(.title)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .frame(height: 45)
            .frame(maxWidth: .infinity)
            .padding(5)
            .padding(.horizontal)
            .background(Color.red)
            .clipShape(RoundedRectangle(cornerRadius: 10))

        } //:VSTACK
        .onAppear(perform: {
            NotiManager.shared.requestNotificationAuthorization()
            
            NotiManager.shared.getPendingNotification { count in
                vm.pendingCount = count
            }
        })
        .padding(50)
        .onChange(of: scenePhage) { oldValue, newValue in
            if newValue == .active {
                NotiManager.shared.getPendingNotification { count in
                    vm.pendingCount = count
                }
            }
        }
    }//:body
}

#Preview {
    SimpleTimerAlarm()
}

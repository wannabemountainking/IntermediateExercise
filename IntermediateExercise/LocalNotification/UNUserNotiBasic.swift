//
//  UNUserNotiBasic.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 2/1/26.
//

import SwiftUI


class NotificationManager {
    static let instance = NotificationManager()
    private init() {}
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (authorized, error) in
            if let error {
                print("에러: \(error)")
            } else {
                print("성공")
            }
        }
    }
    
    func timeNotification() {
        //1. content 만들기
        let content = UNMutableNotificationContent()
        content.title = "Local Notification 테스트 1"
        content.subtitle = "앱 알람 테스트 중입니다"
        content.sound = .default
        content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        
        //2. trigger 만들기
        // 시간 기반
        let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
//        // 날짜 기반
//        var dateCompo = DateComponents()
//        dateCompo.hour = 21
//        dateCompo.minute = 33
//        let dateTrigger = UNCalendarNotificationTrigger(dateMatching: dateCompo, repeats: true)
        
        //3. 요청 등록 request 만들기
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: timeTrigger
        )
        
        // 4. 요청 호출
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleNotification() {
        //1. content 만들기
        let content = UNMutableNotificationContent()
        content.title = "Local Notification 테스트 1"
        content.subtitle = "앱 알람 테스트 중입니다"
        content.sound = .default
        content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        
        //2. trigger 만들기
//        // 시간 기반
//        let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        // 날짜 기반
        var dateCompo = DateComponents()
        dateCompo.hour = 21
        dateCompo.minute = 33
        let dateTrigger = UNCalendarNotificationTrigger(dateMatching: dateCompo, repeats: true)
        
        //3. 요청 등록 request 만들기
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: dateTrigger
        )
        
        // 4. 요청 호출
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelNotification() {
        // 1. pending 알림 모두 제거
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        // 2. delivered 알라미 모두 제거
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}


struct UNUserNotiBasic: View {
    
    @Environment(\.scenePhase) var scenePhage
    
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Text("Local Notification")
                Text("테스트 앱")
            }
            .font(.title)
            .fontWeight(.semibold)
            .fontDesign(.rounded)
            .padding()
            Divider()
                .padding()
            VStack(spacing: 40) {
                buttonViewCustom(text: "권한 요청하기") {
                    NotificationManager.instance.requestAuthorization()
                }
                buttonViewCustom(text: "Time Notificiation") {
                    NotificationManager.instance.timeNotification()
                }
                buttonViewCustom(text: "Calendar Notification") {
                    NotificationManager.instance.scheduleNotification()
                }
                buttonViewCustom(text: "Notification 취소하기") {
                    NotificationManager.instance.cancelNotification()
                }
            }
            .onChange(of: scenePhage) { oldValue, newValue in
                if newValue == .active {
                    UIApplication.shared.applicationIconBadgeNumber = 0
                }
            }
            
            Spacer()
        }
        
    }
    
    @ViewBuilder
    private func buttonViewCustom(text: String, action: @escaping () -> Void) -> some View {
        Button(text) {
            //action
            action()
        }
        .font(.title2)
        .fontWeight(.semibold)
        .foregroundStyle(.black)
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(Color.green)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 30)
    }
}


#Preview {
    UNUserNotiBasic()
}

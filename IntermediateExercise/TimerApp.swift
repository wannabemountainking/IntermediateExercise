//
//  TimerApp.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 1/23/26.
//

import SwiftUI
import Combine

@MainActor
class TimerViewModel: ObservableObject {
    @Published var count: Int = 0
    @Published var isRunning: Bool = false
    
    private var timerTask: Task<Void, Never>?
    
    func startTimer() {
        // 이미 타이머가 있는가?
        guard timerTask == nil else { return }
        isRunning = true
        
        // 백그라운드에서 Task 실행
        timerTask = Task {
            while !Task.isCancelled { // 취소될때까지 돌린다
                try? await Task.sleep(for: .seconds(1))
                // UIUpdate는 Main에서
                if !Task.isCancelled {
                    self.count += 1
                }
            }
        }
    }
    
    func stopTimer() { // 잠시 멈춤
        timerTask?.cancel() // Task 취소
        timerTask = nil
        isRunning = false
    }
    
    func resetTimer() { // 완전 새롭게 시작
        stopTimer()
        count = 0
    }
}

struct TimerApp: View {
    @StateObject private var vm = TimerViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("\(vm.count) 초")
                .font(.title)
                .fontWeight(.heavy)
                .padding(30)
            
            HStack(spacing: 30) {
                Button(vm.isRunning ? "Stop" : "Start") {
                    //action
                    if vm.isRunning {
                        vm.stopTimer()
                    } else {
                        vm.startTimer()
                    }
                }
                .font(.title3)
                .fontWeight(.semibold)
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .foregroundStyle(.white)
                .background(vm.isRunning ? Color.red : Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(20)
                
                Button("Reset") {
                    vm.resetTimer()
                }
                .font(.title3)
                .fontWeight(.semibold)
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .foregroundStyle(.white)
                .background(.gray)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(20)
            }
        }
    }
}

#Preview {
    TimerApp()
}

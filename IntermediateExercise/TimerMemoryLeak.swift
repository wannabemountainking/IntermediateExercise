//
//  TimerMemoryLeak.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 1/23/26.
//

import SwiftUI
import Combine


class TimerMemoryLeakViewModel: ObservableObject {
    @Published var count = 10
    private var task: Task<Void, Never>?
    
    func start() {
        task?.cancel() // 기존 Task 삭제
        
        task = Task { [weak self] in
            guard let self else {
                print("ViewModel이 이미 해제됨")
                return
            }
            
            while self.count > 0 {
                try? await Task.sleep(for: .seconds(1))
                
                // 또 self확인
//                guard let self else {
//                    print("타이머 실행 중 ViewModel 해제됨")
//                    return
//                }
                
                if Task.isCancelled {return}
                
                self.count -= 1
            }
            
        }
    }
    
    func stop() {
        task?.cancel()
        task = nil
    }
    
    deinit {
        print("TimerMemoryLeakModel 끝남")
        task?.cancel()
    }
}

struct TimerMemoryLeak: View {
    @StateObject private var vm = TimerMemoryLeakViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("\(vm.count) 초")
                
                NavigationLink("다음 화면") {
                    Text("새 화면")
                }
            }
            .onAppear {
                vm.start()
            }
        }
    }
}

#Preview {
    TimerMemoryLeak()
}

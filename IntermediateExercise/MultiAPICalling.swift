//
//  MultiAPICalling.swift
//  IntermediateExercise
//
//  Created by yoonie on 1/22/26.
//

import SwiftUI
import Combine


class APIViewModel: ObservableObject {
    @Published var userInfo: String?
    @Published var boardLists: [String] = []
    @Published var numberOfNotifications: Int?
    @Published var isLoading: Bool = false
    @Published var progress: Double = 0.0
    @Published var progressText: String = ""
    
    func fetchAllData() {
        userInfo = nil
        boardLists = []
        numberOfNotifications = nil
        isLoading = true
        progress = 0.0
        
        let group = DispatchGroup()
        var completedCount: Int = 0
        let totalCount: Int = 3
        
        // 사용자 정보 API
        group.enter()
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 2)
            DispatchQueue.main.async {
                self.userInfo = "김도윤"
                completedCount += 1
                self.progress = Double(completedCount) / Double(totalCount)
                self.progressText = "\(completedCount) / \(totalCount) 완료"
                group.leave()
            }
        }
        
        // 게시물 목록 API
        group.enter()
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 3)
            DispatchQueue.main.async {
                self.boardLists = ["I", "You", "We"]
                completedCount += 1
                self.progress = Double(completedCount) / Double(totalCount)
                self.progressText = "\(completedCount) / \(totalCount) 완료"
                group.leave()
            }
        }
        
        // 알림 갯수 API
        group.enter()
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 1)
            DispatchQueue.main.async {
                self.numberOfNotifications = 7
                completedCount += 1
                self.progress = Double(completedCount) / Double(completedCount)
                self.progressText = "\(completedCount) / \(totalCount) 완료"
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.isLoading = false
            self.progressText = "\(completedCount) / \(totalCount) 완료 3개 API 호출 완료"
        }
    }
}

struct MultiAPICalling: View {
    @StateObject private var vm = APIViewModel()
    
    var body: some View {
        VStack {
            Button("get Infos") {
                vm.fetchAllData()
            }
            .disabled(vm.isLoading)
            
            if vm.isLoading {
                VStack(spacing: 20) {
                    ProgressView(value: vm.progress) {
                        Text("로딩 중...")
                    } currentValueLabel: {
                        Text(vm.progressText)
                    }
                    .tint(.blue)
                }
            }
        }
        
        Form {
            Section("사용자 정보") {
                Text(vm.userInfo ?? "없음")
            }
            Section("게시물 목록") {
                ForEach(vm.boardLists, id: \.self) { item in
                    Text(item)
                }
            }
            Section("알림 갯수") {
                Text("\(vm.numberOfNotifications ?? 0)개")
            }
        }
    }
}

#Preview {
    MultiAPICalling()
}

//
//  MultiAPICalling.swift
//  IntermediateExercise
//
//  Created by yoonie on 1/22/26.
//

import SwiftUI
import Combine


<<<<<<< HEAD
=======
enum TaskResult {
    case userInfo(String)
    case boardLists([String])
    case notifications(Int)
}

>>>>>>> origin/main
class APIViewModel: ObservableObject {
    @Published var userInfo: String?
    @Published var boardLists: [String] = []
    @Published var numberOfNotifications: Int?
    @Published var isLoading: Bool = false
    @Published var progress: Double = 0.0
    @Published var progressText: String = ""
    
<<<<<<< HEAD
    func fetchAllData() {
=======
    @MainActor
    func fetchAllData() async {
>>>>>>> origin/main
        userInfo = nil
        boardLists = []
        numberOfNotifications = nil
        isLoading = true
        progress = 0.0
        
<<<<<<< HEAD
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
=======
        var completedCount = 0
        let totalCount = 3
        
        // 비동기 TaskGroup으로 일시키기
        await withTaskGroup(of: TaskResult.self) { group in
            // 1. 각 함수의 작업만 걸어 놓고 기다리기
            group.addTask {
                let result = await self.fetchserInfo()
                return .userInfo(result)
            }
            group.addTask {
                let result = await self.fetchBoardList()
                return .boardLists(result)
            }
            group.addTask {
                let result = await self.fetchNumberOfNotis()
                return .notifications(result)
            }
            
            // 2. 시킨 일 기다렸다가 모아서 받기
            for await result in group {
                completedCount += 1
                
                // 3. 결과result에 따라 업데이트
                switch result {
                case .userInfo(let user):
                    self.userInfo = user
                case .boardLists(let boards):
                    self.boardLists = boards
                case .notifications(let notis):
                    self.numberOfNotifications = notis
                }
                
                // 4. 진행률 표시하기(다운 받을 때마다 @Published 였던 변수들 값이 변하므로 화면도 변함)
                self.progress = Double(completedCount) / Double(totalCount)
                self.progressText = "\((self.progress * 100).formatted(.number.precision(.fractionLength(1))))% 다운로드 완료"
            }
        }
        
        isLoading = false
    }
    
    func fetchserInfo() async -> String{
        try? await Task.sleep(for: .seconds(2))
        return "김도윤"
    }
    
    func fetchBoardList() async -> [String] {
        try? await Task.sleep(for: .seconds(3))
        return ["I", "You", "We"]
    }
    
    func fetchNumberOfNotis() async -> Int {
        try? await Task.sleep(for: .seconds(1))
        return 7
>>>>>>> origin/main
    }
}

struct MultiAPICalling: View {
    @StateObject private var vm = APIViewModel()
    
    var body: some View {
        VStack {
<<<<<<< HEAD
            Button("get Infos") {
                vm.fetchAllData()
            }
            .disabled(vm.isLoading)
=======
            Button {
                Task {
                    await vm.fetchAllData()
                }
            } label: {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("데이터 새로 고침")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(vm.isLoading)
            .padding(.horizontal)
>>>>>>> origin/main
            
            if vm.isLoading {
                VStack(spacing: 20) {
                    ProgressView(value: vm.progress) {
                        Text("로딩 중...")
<<<<<<< HEAD
                    } currentValueLabel: {
                        Text(vm.progressText)
                    }
                    .tint(.blue)
                }
=======
                            .font(.headline)
                    } currentValueLabel: {
                        Text(vm.progressText)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .tint(.blue)
                    
                    Text("완료율: \(Int(vm.progress * 100))%")
                        .font(.title2)
                        .bold()
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
>>>>>>> origin/main
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
<<<<<<< HEAD
=======
        .navigationTitle("대시보드")
        .navigationBarTitleDisplayMode(.inline)
>>>>>>> origin/main
    }
}

#Preview {
    MultiAPICalling()
}

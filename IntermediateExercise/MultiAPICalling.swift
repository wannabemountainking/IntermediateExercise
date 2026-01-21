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
    @Published var userInfoDownloading: Bool = false
    @Published var boardLists: [String] = []
    @Published var boardListsDownloading: Bool = false
    @Published var numberOfNotifications: Int?
    @Published var numberOfNotificationsDownloading: Bool = false
    
    func getUserInfo() {
        userInfoDownloading = true
        defer { userInfoDownloading = false }
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 3)
            self.userInfo = "김도윤"
        }
    }
    
    func getBoardLists() {
        boardListsDownloading = true
        defer { boardListsDownloading = false }
        
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 2)
            self.boardLists = ["나", "너", "우리"]
        }
    }
    
    func getNumberOfNotis() {
        numberOfNotificationsDownloading = true
        defer { numberOfNotificationsDownloading = false}
        
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 1)
            self.numberOfNotifications = 7
        }
    }
}

struct MultiAPICalling: View {
    @StateObject private var vm = APIViewModel()
    @State private var user: String = ""
    @State private var lists: [String] = []
    @State private var numOfNotis: Int = 0
    
    var body: some View {
        Form {
            Button("get Infos") {
                let group = DispatchGroup()
                
                group.enter()
                DispatchQueue.global().async {
                    vm.getUserInfo()
                    group.leave()
                }
                
                group.enter()
                DispatchQueue.global().async {
                    vm.getBoardLists()
                    group.leave()
                }
                
                group.enter()
                DispatchQueue.global().async {
                    vm.getNumberOfNotis()
                    group.leave()
                }
                
                group.notify(queue: .main) {
                    user = vm.userInfo ?? "너"
                    lists = vm.boardLists
                    numOfNotis = vm.numberOfNotifications ?? 0
                }
            }
        }
        
        Text(user)
        List {
            ForEach(lists, id: \.self) { list in
                Text(list)
            }
        }
        Text("\(numOfNotis)개")
    }
}

#Preview {
    MultiAPICalling()
}

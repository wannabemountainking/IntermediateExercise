//
//  ContentView.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 1/4/26.
//

import SwiftUI
import Combine

struct User {
    var name: String?
    var email: String?
    var age: Int?
    var profileImage: String?
}

class UserViewModel: ObservableObject {
    @Published var user: User = User()
    @Published var resultText: String = ""
    
    func setUser(name: String?, email: String?, age: String?, profileIamge: String = "swift") {
        let userAge = age.flatMap { Int($0) }
        user = User(name: name, email: email, age: userAge, profileImage: profileIamge)
    }
    
    func validateUser(user: User) {
        guard let name = user.name else {
            resultText = "이름 미제공"
            return
        }
        guard let email = user.email else {
            resultText = "이메일 미제공"
            return
        }
        
        let _ = user.age ?? 0
        let _ = user.profileImage ?? "swift"
        print(name)
        print(email)
        resultText = "프로필 완료"
    }
}

struct ContentView: View {
    @State private var userVM = UserViewModel()
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var age: String = ""
    @State private var image: String = ""
    
    var body: some View {
        Form {
            Text(userVM.resultText)
                .font(.title.bold())
            
            TextField("이름 입력", text: $name)
            TextField("이메일 입력", text: $email)
            TextField("나이 입력", text: $age)
            TextField("프로필 사진명 입력", text: $image)
            Button("사용자 정보 검증") {
                //action
                userVM.setUser(name: name, email: email, age: age, profileIamge: image)
                userVM.validateUser(user: userVM.user)
            }
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .frame(height: 45)
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(30)
        }
    }
}

#Preview {
    ContentView()
}

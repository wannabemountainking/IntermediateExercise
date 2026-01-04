//
//  LoginSystem.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 1/4/26.
//

import SwiftUI
import Combine

struct LoginInput {
    var userName: String?
    var password: String?
}

class LoginSystemViewModel: ObservableObject {
    @Published var loginInput: LoginInput = LoginInput()
    @Published var isSuccess: Bool = false
    @Published var loginMessage: String = ""
    
    func validateLogin(loginData: LoginInput) {
        guard let username = loginData.userName, !username.isEmpty else {
            loginMessage = "사용자명을 입력하세요"
            isSuccess = false
            return
        }
        guard let password = loginData.password, !password.isEmpty else {
            loginMessage = "비밀번호를 입력하세요"
            isSuccess = false
            return
        }
        guard password.count >= 6 else {
            loginMessage = "비밀번호는 6자 이상이어야 합니다"
            isSuccess = false
            return
        }
        loginMessage = "로그인 성공: \(username)님 환영합니다"
        isSuccess = true
    }
}

struct LoginSystem: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @StateObject private var loginVM: LoginSystemViewModel = LoginSystemViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("사용자명 입력", text: $username)
                SecureField("비밀번호 입력", text: $password)
                Button("로그인 하기") {
                    loginVM.loginInput = LoginInput(userName: username, password: password)
                    loginVM.validateLogin(loginData: loginVM.loginInput)
                }
                Text(loginVM.loginMessage)
                    .foregroundStyle(loginVM.isSuccess ? .green : .red)
            }
            .navigationTitle("로그인")
        }
    }
}

#Preview {
    LoginSystem()
}

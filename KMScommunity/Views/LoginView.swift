//
//  LoginView.swift
//  KMScommunity
//
//  Created by 이민교 on 2023/01/01.
//

import SwiftUI

struct LoginView: View {
    @State private var user = LoginUser()
    
    @State private var isLoginValid: Bool = false
    @State private var shouldShowLoginAlert: Bool = false

    @State private var isAutoLogin : Bool = false
    @State private var isLoginAlertShow : Bool = false
    
    @State private var isLoading : Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 16.0) {
                GrayBorderTextFieldView(string: $user.userId, header: "User ID", placeholder: "Type ID")
                GrayBorderSecuredFieldView(string: $user.userPw, header: "Password", placeholder: "Type Password")
                HStack {
                    Toggle(isOn: $isAutoLogin) {
                        Text("자동 로그인")
                        
                    }
                    .toggleStyle(ChecklistToggleStyle())
                    Spacer()
                    NavigationLink(destination: MainView(), isActive: $isLoginValid) {
                        Button("Login") {
                            Task {
                                do {
                                    isLoading = true
                                    
                                    try await user.postUserLogin()
                                    isLoginValid = true
                                    if isAutoLogin {
                                        UserDefaults.standard.set(user.userId, forKey: "userId")
                                        UserDefaults.standard.set(user.userPw, forKey: "userPw")
                                        UserDefaults.standard.set(isAutoLogin, forKey: "isAutoLogin")
                                    }
                                } catch {
                                    // error
                                    isLoginValid = false
                                    isLoginAlertShow = true
                                    isLoading = false
                                }
                                isLoading = false
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .alert("로그인 실패", isPresented: $isLoginAlertShow, actions: {}) {
                        // 로그인 실패와 에러가 처리가 안되고있긴함.
                        Text("아이디와 비밀번호를 다시 확인해주세요.")
                    }
                }
                Divider()
                NavigationLink(destination: RegisterView()) {
                    Text("Register")
                    
                }
                .padding()
                .buttonStyle(.bordered)
                
                
            }
            .padding()
            .task {
                isLoading = true
                let storedAutoLogin = UserDefaults.standard.bool(forKey: "isAutoLogin")
                
                if storedAutoLogin == true, let storedUserId = UserDefaults.standard.string(forKey: "userId"), let storedUserPw = UserDefaults.standard.string(forKey: "userPw") {
                    
                    user.userId = storedUserId
                    user.userPw = storedUserPw
                    isAutoLogin = storedAutoLogin
                    // login 시키기.
                    // navigation 하면 된다.
                    do {
                        try await user.postUserLogin()
                        isLoginValid = true
                    } catch {
                        isLoginValid = false
                        isLoginAlertShow = true
                        isLoading = false
                    }
                }
                isLoading = false
            }
            if isLoading {
                ProgressView()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView()
        }
    }
}

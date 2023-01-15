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
    var body: some View {
        VStack {
            TextField("UserID", text: $user.userId)
                .border(.secondary)
            SecureField("Password", text: $user.userPw)
                .border(.secondary)
            HStack {
                Toggle(isOn: $isAutoLogin) {
                    Text("자동 로그인")
                }
            
                NavigationLink(destination: MainView(), isActive: $isLoginValid) {
                    Text("NaviLogin")
                        .onTapGesture {
                            Task {
                                do {
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
                                }
                            }
                        }
                }
                .alert("회원가입 실패", isPresented: $isLoginAlertShow, actions: {}) {
                    Text("아이디와 비밀번호를 다시 확인해주세요.")
                }
                NavigationLink(destination: RegisterView()) {
                    Text("Register")
                }
            }
        }
        .padding()
        .task {
            print("asdf")
            
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
                }
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

//
//  LoginView.swift
//  KMScommunity
//
//  Created by 이민교 on 2023/01/01.
//

import SwiftUI

struct LoginView: View {
    @State private var user = LoginUser()
    @State private var userId = ""
    @State private var password = ""
    
    @State private var isLoginValid: Bool = false
    @State private var shouldShowLoginAlert: Bool = false
    @State var memberId : String = ""
    @State var nickname : String = ""

    @State private var isLoginAlertShow : Bool = false
    var body: some View {
        VStack {
            TextField("UserID", text: $user.userId)
                .border(.secondary)
            SecureField("Password", text: $user.userPw)
                .border(.secondary)
            HStack {
                NavigationLink(destination: MainView(), isActive: $isLoginValid) {
                    Text("NaviLogin")
                        .onTapGesture {
                            Task {
                                do {
                                    try await user.postUserLogin()
                                    isLoginValid = true
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
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView()
        }
    }
}

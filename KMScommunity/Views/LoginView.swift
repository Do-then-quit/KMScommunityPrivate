//
//  LoginView.swift
//  KMScommunity
//
//  Created by 이민교 on 2023/01/01.
//

import SwiftUI

struct LoginView: View {
    @State private var userId = ""
    @State private var password = ""
    
    @State private var isLoginValid: Bool = false
    @State private var shouldShowLoginAlert: Bool = false
    @State var memberId : Int64 = -1
    @State var nickname : String = ""

    var body: some View {
        VStack {
            TextField("UserID", text: $userId)
                .border(.secondary)
            SecureField("Password", text: $password)
                .border(.secondary)
            HStack {
                
                NavigationLink(destination: MainView(memberId: memberId, nickname: nickname), isActive: $isLoginValid) {
                    Text("NaviLogin")
                        .onTapGesture {
                            Task {
                                let loginResponse = await postUserLogin(loginId:userId,loginPw:password)
                                if loginResponse.code == 200 {
                                    print("Login in view")
                                    memberId = loginResponse.data.memberId
                                    nickname = loginResponse.data.nickname
                                    isLoginValid = true
                                } else {
                                    print("Not logined in view")
                                    isLoginValid = false
                                }
                                
                            }
                        }
                        
                    
                }

                NavigationLink(destination: RegisterView()) {
                    Text("Register")
                }

            }

        }
        .padding()
    }
    
    func changeParameters(loginResponse: LoginResponse) -> Void {
        memberId = loginResponse.data.memberId
        nickname = loginResponse.data.nickname
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView()
        }
    }
}

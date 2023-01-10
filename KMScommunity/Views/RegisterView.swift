//
//  ContentView.swift
//  KMScommunity
//
//  Created by 이민교 on 2022/12/30.
//

import SwiftUI
//{
//  "email": "string",
//  "name": "string",
//  "nickname": "string",
//  "phone": "string",
//  "userId": "string",
//  "userPw": "string"
//}
struct RegisterView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var user: RegistUser = RegistUser()
    
//    @State private var userId: String = ""
//    @State private var userPw: String = ""
//    @State private var email: String = ""
//    @State private var name: String = ""
//    @State private var nickname: String = ""
//    @State private var phone: String = ""
    
    @State private var isShowAlert = false
    @State private var isIdDoubleChecked = false
    
    var body: some View {
        VStack {
            TextField("UserID", text: $user.userId)
                .border(.secondary)
            Button("중복 확인", action: idCheck)
                .alert(isPresented: $isShowAlert) {
                    if isIdDoubleChecked {
                        return Alert(title: Text("Id Okay"))
                    } else {
                        return Alert(title: Text("Id Doubled"))
                    }
                }
            
            SecureField("Password", text: $user.userPw)
                .border(.secondary)
            TextField("Email", text: $user.email)
                .border(.secondary)
            TextField("Name", text: $user.name)
                .border(.secondary)
            TextField("phone", text: $user.phone)
                .border(.secondary)
            TextField("nickname", text: $user.nickname)
                .border(.secondary)
            Button("회원가입") {
                Task {
                    do {
                        try await user.postUserRegist()
                        dismiss()
                    } catch RegistUser.UserError.internalError {
                        print("Big Error internal Error")
                    } catch { //rest errors
                        //alert do this again please.
                    }
                }
            }
                //.disabled(!isIdDoubleChecked)
        }
        .padding()
    }
    
    func idCheck() -> Void {
        print(user.userId)
        
        requestGetWithQuery(url: "/user/idValidChk", inputID: user.userId) { (isCompletion: Bool, data: Data) in
            if (isCompletion) {
                //success
                isIdDoubleChecked = true
            } else {
                isIdDoubleChecked = false
            }
        }
        isShowAlert.toggle()
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}

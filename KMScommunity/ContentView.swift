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
struct ContentView: View {
    @State private var userId: String = ""
    @State private var userPw: String = ""
    @State private var email: String = ""
    @State private var name: String = ""
    @State private var nickname: String = ""
    @State private var phone: String = ""
    
    var body: some View {
        VStack {
            TextField("UserID", text: $userId)
                .border(.secondary)
            Button("중복 확인", action: idCheck)
            SecureField("Password", text: $userPw)
                .border(.secondary)
            TextField("Email", text: $email)
                .border(.secondary)
            TextField("Name", text: $name)
                .border(.secondary)
            TextField("phone", text: $phone)
                .border(.secondary)
            TextField("nickname", text: $nickname)
                .border(.secondary)
            Button("회원가입", action: userRegister)
        }
        .padding()
    }
    
    func idCheck() -> Void {
        print(userId)
        requestGetWithQuery(url: "/user/idValidChk", inputID: userId) { (isCompletion: Bool, data: Any) in
            
        }
    }
    func userRegister() -> Void {
        postUserRegister(userId: userId, userPw: userPw, email: email, name: name, phone: phone, nickname: nickname)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

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
    
    @State private var isRegistOkay = false
    @State private var isRegistAlert = false
    
    
    var body: some View {
        VStack {
            TextField("UserID", text: $user.userId)
                .border(.secondary)
                .disabled(isIdDoubleChecked)
            Button("중복 확인", action: {
                Task {
                    do {
                        isIdDoubleChecked = try await user.getIdDoubleCheck()
                    } catch {
                        print("Not wanted Error Occur")
                    }
                    isShowAlert.toggle()
                    
                }
            })
            .alert("id 중복 결과", isPresented: $isShowAlert, actions: {}, message: {
                if isIdDoubleChecked {
                    Text("Id Okay")
                } else {
                    Text("Id Doubled")
                }
            })
            
            
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
                        isRegistOkay = true
                    } catch RegistUser.UserError.internalError {
                        print("Big Error internal Error")
                        isRegistOkay = false
                    } catch { //rest errors
                        //alert do this again please.
                        isRegistOkay = false
                        
                    }
                    isRegistAlert = true
                }
            }
            .disabled(!isIdDoubleChecked)
            .alert("회원가입 결과", isPresented: $isRegistAlert) {
                Button("확인") {
                    if isRegistOkay {
                        dismiss()
                    }
                }
            } message: {
                if isRegistOkay {
                    Text("회원가입 완료")
                } else {
                    Text("회원가입 실패")
                }
            }

            
        }
        .padding()
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}

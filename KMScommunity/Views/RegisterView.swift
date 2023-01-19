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
    
    @State private var isIdAlert = false
    @State private var isIdDoubleChecked = false
    
    @State private var isNickAlert = false
    @State private var isNickDoubleChecked = false
    
    @State private var isRegistOkay = false
    @State private var isRegistAlert = false
    
    
    var body: some View {
        VStack(spacing: 16.0) {
            VStack {
                HStack {
                    GrayBorderTextFieldView(string: $user.userId, header: "UserID", placeholder: "Type ID")
                        .disabled(isIdDoubleChecked)
                    
                    Button("중복 확인", action: {
                        Task {
                            do {
                                isIdDoubleChecked = try await user.getIdDoubleCheck()
                            } catch {
                                print("Not wanted Error Occur")
                                fatalError(error.localizedDescription)
                            }
                            isIdAlert.toggle()
                        }
                    })
                    .buttonStyle(.bordered)
                    .alert("id 중복 결과", isPresented: $isIdAlert, actions: {}, message: {
                        if isIdDoubleChecked {
                            Text("Id Okay")
                        } else {
                            Text("Id Doubled")
                        }
                    })
                }
            }
            GrayBorderSecuredFieldView(string: $user.userPw, header: "Password", placeholder: "Type Password")
            GrayBorderTextFieldView(string: $user.email, header: "E-Mail", placeholder: "Type E-mail")
            GrayBorderTextFieldView(string: $user.name, header: "Name", placeholder: "Type Name")
            GrayBorderTextFieldView(string: $user.phone, header: "Phone", placeholder: "Type Phone Number")
            HStack {
                GrayBorderTextFieldView(string: $user.nickname, header: "Nickname", placeholder: "Type Nickname")
                    .disabled(isNickDoubleChecked)
                Button("중복확인") {
                    // 닉네임 중복 확인 완료 되면 회원가입 되게 하자.
                    Task {
                        do {
                            isNickDoubleChecked = try await user.getIdDoubleCheck()
                        } catch {
                            print("Not wanted Error Occur")
                            fatalError(error.localizedDescription)
                        }
                        isNickAlert.toggle()
                    }
                }
                .buttonStyle(.bordered)
                .alert("닉네임 중복 결과", isPresented: $isNickAlert, actions: {}, message: {
                    if isNickDoubleChecked {
                        Text("Nick Okay")
                    } else {
                        Text("Nick Doubled")
                    }
                })
                
            }
            
            
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
            .buttonStyle(.borderedProminent)
            .disabled(!(isIdDoubleChecked && isNickDoubleChecked))
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
                    Text("회원가입 실패, 이미 가입된 핸드폰 번호가 있습니다.")
                }
            }
        }
        .padding()
        .navigationTitle("Sign Up")
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RegisterView()
        }
    }
}

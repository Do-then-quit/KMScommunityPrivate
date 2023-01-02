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
    @State private var naviSelection: String? = nil

    var body: some View {
        VStack {
            TextField("UserID", text: $userId)
                .border(.secondary)
            SecureField("Password", text: $password)
                .border(.secondary)
            HStack {
                NavigationLink(destination: MainView()) {
                    Text("Login")
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

//
//  ContentView.swift
//  KMScommunity
//
//  Created by 이민교 on 2022/12/30.
//

import SwiftUI

struct ContentView: View {
    @State private var userId: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            TextField("UserID", text: $userId)
                .border(.secondary)
            Button("중복 확인", action: idCheck)
            SecureField("Password", text: $password)
                .border(.secondary)
        }
        .padding()
    }
    
    func idCheck() -> Void {
        print(userId)
        requestGetWithQuery(url: "/user/idValidChk", inputID: userId) { (isCompletion: Bool, data: Any) in
            
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

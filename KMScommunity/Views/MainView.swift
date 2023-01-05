//
//  MainView.swift
//  KMScommunity
//
//  Created by 이민교 on 2023/01/02.
//

import SwiftUI

struct MainView: View {
    var memberId: String
    var nickname: String
    init(memberId: String, nickname: String) {
        UITabBar.appearance().scrollEdgeAppearance = .init()
        self.memberId = memberId
        self.nickname = nickname
        myMemberId = memberId
    }
    
    
    
    var body: some View {
        TabView {
            BoardView(nickname: nickname)
                .tabItem {
                    Text("게시판")
                }
            Text("프로필뷰")
                .tabItem {
                    Text("프로필")
                }
        }
        .navigationBarBackButtonHidden()
        
        
    }
        
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(memberId: "", nickname: "TestName")
    }
}

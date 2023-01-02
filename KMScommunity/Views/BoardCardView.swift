//
//  BoardCardView.swift
//  KMScommunity
//
//  Created by 이민교 on 2023/01/02.
//

import SwiftUI

struct BoardCardView: View {
    var body: some View {
        HStack {
            Text("카테고리")
            Divider()
            VStack {
                Text("제목")
                Text("글쓴이")
            }
            Spacer()
            Divider()
            VStack {
                Label("23", systemImage: "text.bubble")
                Label("24", systemImage: "heart")
                Label("123", systemImage: "cursorarrow")
            }
            
        }
    }
}

struct BoardCardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardCardView()
            .previewLayout(.fixed(width: 400, height: 55))
    }
}
